module Myob
  module Api
    module Model
      class Customer < Myob::Api::Model::Base
        def model_route
          'Contact/Customer'
        end
      end
    end
  end
end