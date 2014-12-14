module Myob
  module Api
    module Model
      class CustomerPayment < Base
        def model_route
          'Sale/CustomerPayment'
        end
      end
    end
  end
end