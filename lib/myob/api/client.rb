require 'Base64'

module Myob
  module Api
    class Client
      include Myob::Api::Helpers

      attr_reader   :current_company_file
      attr_accessor :company_file_guid

      def initialize(options)
        model :CompanyFile
        model :Contact
        model :Customer

        @consumer     = options[:consumer]
        @company_file = options[:company_file]
        @access_token = options[:access_token]
        @client       = OAuth2::Client.new(@consumer[:key], @consumer[:secret])
        @company_file_guid = nil
      end

      def headers
        {
          'x-myobapi-key'     => @consumer[:key],
          'x-myobapi-version' => 'v2',
          'x-myobapi-cftoken' => Base64.encode64("#{@company_file[:username]}:#{@company_file[:password]}") || '',
        }
      end

      def connection
        @auth_connection ||= OAuth2::AccessToken.new(@client, @access_token)
      end
    end
  end
end