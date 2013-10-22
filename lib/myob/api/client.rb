require 'Base64'

module Myob
  module Api
    class Client
      include Myob::Api::Helpers

      attr_reader :current_company_file

      def initialize(options)
        model :CompanyFile
        model :Contact
        model :Customer

        @consumer             = options[:consumer]
        @access_token         = options[:access_token]
        @current_company_file = {}
        @client               = OAuth2::Client.new(@consumer[:key], @consumer[:secret])

        if options[:company_file]
          @current_company_file = select_company_file(options[:company_file])
        end
      end

      def headers
        {
          'x-myobapi-key'     => @consumer[:key],
          'x-myobapi-version' => 'v2',
          'x-myobapi-cftoken' => @current_company_file[:token] || '',
        }
      end

      def select_company_file(company_file)
        company_file_id = self.company_file.first('Name' => company_file[:name])['Id']
        @current_company_file = {
          :id    => company_file_id,
          :token => Base64.encode64("#{company_file[:username]}:#{company_file[:password]}"),
        }
      end

      def connection
        @auth_connection ||= OAuth2::AccessToken.new(@client, @access_token)
      end
    end
  end
end