module Myob
  module Api
    module Model
      class CurrentUser < Myob::Api::Model::Base
        def model_route
          'CurrentUser'
        end
      end
    end
  end
end