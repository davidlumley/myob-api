module Myob
  module Api
    module Model
      class Base

        API_URL = 'https://api.myob.com/accountright/'

        def initialize(client, model_name)
          @client     = client
          @model_name = model_name || 'Base'
        end

        def model_route
          @model_name.to_s
        end

        def all
          parse_response(@client.connection.get(self.url, {:headers => @client.headers}))
        end

        def url
          if self.model_route == ''
            "#{API_URL}"
          else
            "#{API_URL}#{@client.company_file_guid}/#{self.model_route}"
          end
        end

        private

        def parse_response(response)
          JSON.parse(response.body)
        end

      end
    end
  end
end