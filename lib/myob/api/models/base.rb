module Myob
  module Api
    module Model
      class Base

        API_URL = 'https://api.myob.com/accountright/'
        QUERY_OPTIONS = [:orderby, :top, :skip, :filter]

        def initialize(client, model_name)
          @client          = client
          @model_name      = model_name || 'Base'
          @next_page_link  = nil
        end

        def model_route
          @model_name.to_s
        end

        def all(params = nil)
          perform_request(self.url(nil, params))
        end
        alias_method :get, :all

        def records(params = nil)
          response = all(params)
          response.is_a?(Hash) && response.key?('Items') ? response['Items'] : response
        end
        
        def next_page?
          !!@next_page_link
        end
        
        def next_page(params = nil)
          perform_request(@next_page_link, params)
        end

        def all_items(params = nil)
          results = all(params)["Items"]
          while next_page?
            results += next_page(params)["Items"] || []
          end
          results
        end
        
        def find(id)
          object = { 'UID' => id }
          perform_request(self.url(object))
        end
        
        def first(params = nil)
          all(params).first
        end

        def save(object)
          new_record?(object) ? create(object) : update(object)
        end

        def destroy(object)
          @client.connection.delete(self.url(object), :headers => @client.headers)
        end

        def url(object = nil, params = nil)
          url = if self.model_route == ''
            "#{API_URL}"
          else
            "#{API_URL}#{@client.current_company_file[:id]}/#{self.model_route}#{"/#{object['UID']}" if object && object['UID']}"
          end

          if params.is_a?(Hash)
            query = query_string(params)
            url += "?#{query}" if !query.nil? && query.length > 0
          end

          url
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
        
        def resource_url
          "#{API_URL}#{@client.current_company_file[:id]}/#{self.model_route}"
        end
        
        def perform_request(url)
          model_data = parse_response(@client.connection.get(url, {:headers => @client.headers}))
          @next_page_link = model_data['NextPageLink'] if self.model_route != ''
          model_data
        end

        def query_string(params)
          params.map do |key, value|
            if QUERY_OPTIONS.include?(key)
              value = build_filter(value) if key == :filter
              key = "$#{key}"
            end

            "#{key}=#{CGI.escape(value.to_s)}"
          end.join('&')
        end

        def build_filter(value)
          return value unless value.is_a?(Hash)

          value.map { |key, value| "#{key} eq '#{value.to_s.gsub("'", %q(\\\'))}'" }.join(' and ')
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
