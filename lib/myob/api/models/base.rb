module Myob
  module Api
    module Model
      class Base

        API_URL = 'https://api.myob.com/accountright/'
        QUERY_OPTIONS = [:orderby, :top, :skip, :filter]

        def initialize(client, model_name)
          @client     = client
          @model_name = model_name || 'Base'
        end

        def model_route
          @model_name.to_s
        end

        def all(params = nil)
          response = parse_response(@client.connection.get(self.url(nil, params), :headers => @client.headers))
          # response.is_a?(Hash) && response.key?('Items') ? response['Items'] : response # see comment at https://github.com/davidlumley/myob-api/pull/8/files#diff-f2e29cd96ba8e40ff4a737a945d2bf94R20
          response
        end

        alias_method :get, :all

        def first(params = nil)
          all(params).first
        end

        def find(uid)
          parse_response(@client.connection.get(self.url('UID' => uid), :headers => @client.headers))
        end

        def save(object)
          new_record?(object) ? create(object) : update(object)
        end

        def url(object = nil, params = nil)
          url = if self.model_route == ''
            "#{API_URL}"
          else
            "#{API_URL}#{@client.current_company_file[:id]}/#{self.model_route}#{"/#{object['UID']}" if object && object['UID']}"
          end

          if params.is_a?(Hash)
            query = query_string(params)
            url += "?#{query}" if query.present?
          end

          url
        end

        def new_record?(object)
          object["UID"].nil? || object["UID"] == ""
        end

        private

        def create(object)
          object = typecast(object)
          response = @client.connection.post(self.url, :headers => @client.headers, :body => object.to_json)
          response.status == 201
        end

        def update(object)
          object = typecast(object)
          response = @client.connection.put(self.url(object), :headers => @client.headers, :body => object.to_json)
          response.status == 200
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

        def query_string(params)
          params.map do |key, value|
            if QUERY_OPTIONS.include? key
              value = build_filter(value) if [:filter, :filters].include?(key)
              key = "$#{key}"
            end

            "#{key}=#{CGI.escape(value.to_s)}"
          end.join '&'
        end

        def build_filter(value)
          return value unless value.is_a? Hash

          value.map { |key, value| "#{key} eq '#{value.to_s.gsub("'", %q(\\\'))}'" }.join ' and '
        end

      end
    end
  end
end
