module Myob
  module Api
    module Model
      class Invoice < Myob::Api::Model::Base
        def model_route
          'Sale/Invoice'
        end
      end
    end
  end
end