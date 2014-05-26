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

        def all(query = nil)
          model_data = parse_response(@client.connection.get(self.url, {:headers => @client.headers}))
          if query
            return process_query(model_data, query)
          else
            return model_data
          end
        end

        def get(query = nil)
          all(query)
        end

        def first(query = nil)
          model_data = self.all(query)
          model_data[0] if model_data.length > 0
        end

        def url
          if self.model_route == ''
            "#{API_URL}"
          else
            "#{API_URL}#{@client.current_company_file[:id]}/#{self.model_route}"
          end
        end

        private

        def parse_response(response)
          JSON.parse(response.body)
        end

        def process_query(data, query)
          query.each do |property, value|
            data.select!{|x| x[property] == value}
          end
          data
        end

      end
    end
  end
end