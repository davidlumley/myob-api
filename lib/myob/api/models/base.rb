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

        def save(object)
          new_record?(object) ? create(object) : update(object)
        end

        def url(object = nil)
          if self.model_route == ''
            "#{API_URL}"
          else
            "#{API_URL}#{@client.current_company_file[:id]}/#{self.model_route}#{"/#{object['UID']}" if object && object['UID']}"
          end
        end

        def new_record?(object)
          object["UID"].nil? || object["UID"] == ""
        end

        private
        def create(object)
          object = typecast(object)
          response = @client.connection.post(self.url, {:headers => @client.headers, :body => object.to_json})
        end

        def update(object)
          object = typecast(object)
          response = @client.connection.put(self.url(object), {:headers => @client.headers, :body => object.to_json})
        end

        def typecast(object)
          returned_object = object.dup # don't change the original object

          returned_object.each do |key, value|
            if value.respond_to?(:strftime)
              returned_object[key] = value.strftime(date_formatter)
            end
          end

          returned_object
        end

        def date_formatter
          "%Y-%m-%dT%H:%M:%S"
        end

        def parse_response(response)
          JSON.parse(response.body)
        end

        def process_query(data, query)
          query.each do |property, value|
            data.select! {|x| x[property] == value}
          end
          data
        end

      end
    end
  end
end
