require 'base64'
require 'oauth2'

module Myob
  module Api
    class Client
      include Myob::Api::Helpers

      attr_reader :current_company_file, :client, :current_company_file_url

      def initialize(options)
        Myob::Api::Model::Base.subclasses.each {|c| model(c.name.split("::").last)}

        @redirect_uri         = options[:redirect_uri]
        @consumer             = options[:consumer]
        @access_token         = options[:access_token]
        @refresh_token        = options[:refresh_token]

        @client               = OAuth2::Client.new(@consumer[:key], @consumer[:secret], {
          :site          => 'https://secure.myob.com',
          :authorize_url => '/oauth2/account/authorize',
          :token_url     => '/oauth2/v1/authorize',
        })

        # on client init, if we have a company file already, get the appropriate base URL for this company file from MYOB
        provided_company_file = options[:selected_company_file] || options[:company_file]
        select_company_file(provided_company_file) if provided_company_file
      end

      def get_access_code_url(params = {})
        @client.auth_code.authorize_url(params.merge(scope: 'CompanyFile', redirect_uri: @redirect_uri))
      end

      def get_access_token(access_code)
        @token         = @client.auth_code.get_token(access_code, redirect_uri: @redirect_uri)
        @access_token  = @token.token
        @expires_at    = @token.expires_at
        @refresh_token = @token.refresh_token
        @token
      end

      def headers
        token = (@current_company_file || {})[:token]
        if token.nil? || token == ''
          # if token is blank assume we are using federated login - http://myobapi.tumblr.com/post/109848079164/2015-1-release-notes
          {
            'x-myobapi-key'     => @consumer[:key],
            'x-myobapi-version' => 'v2',
            'Content-Type'      => 'application/json'
          }
        else
          {
            'x-myobapi-key'     => @consumer[:key],
            'x-myobapi-version' => 'v2',
            'x-myobapi-cftoken' => token,
            'Content-Type'      => 'application/json'
          }
        end
      end

      # given some company file credentials, connect to MYOB and get the appropriate company file object.
      # store its ID and token for auth'ing requests, and its URL to ensure we talk to the right MYOB server.
      #
      # `company_file` should be hash. accepted forms:
      #
      # {name: String, username: String, password: String}
      # {id: String, token: String}
      def select_company_file(company_file)
        # store the provided company file as an ivar so we can use it for subsequent requests
        # we need the token from it to make the initial request to get company files
        @current_company_file ||= company_file if company_file[:token]

        selected_company_file = company_files.find {|file|
          if company_file[:name]
            file['Name'] == company_file[:name]
          elsif company_file[:id]
            file['Id'] == company_file[:id]
          end
        }

        if selected_company_file
          token = company_file[:token]
          if (token.nil? || token == '') && !company_file[:username].nil? && company_file[:username] != '' && !company_file[:password].nil?
            # if we have been given login details, encode them into a token
            token = Base64.encode64("#{company_file[:username]}:#{company_file[:password]}")
          end
          @current_company_file = {
            :id    => selected_company_file['Id'],
            :token => token
          }
          @current_company_file_url = selected_company_file['Uri']
        end
      end

      def connection
        if @refresh_token
          @auth_connection ||= OAuth2::AccessToken.new(@client, @access_token, {
            :refresh_token => @refresh_token
          }).refresh!
        else
          @auth_connection ||= OAuth2::AccessToken.new(@client, @access_token)
        end
      end

      private
      def company_files
        @company_files ||= self.company_file.all.to_a
      end
    end
  end
end
