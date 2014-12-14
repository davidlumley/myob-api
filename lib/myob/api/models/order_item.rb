module Myob
  module Api
    module Model
      class OrderItem < Base
        def model_route
          'Purchase/Order/Item'
        end
      end
    end
  end
end