module Myob
  module Api
    module Model
      class CompanyFile < Myob::Api::Model::Base
        def model_route
          ''
        end

        def select(guid)
          @client.company_file_guid = guid
        end
      end
    end
  end
end