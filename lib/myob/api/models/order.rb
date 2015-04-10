module Myob
  module Api
    module Model
      class Order < Base
        def model_route
          'Purchase/Order'
        end
      end
    end
  end
end