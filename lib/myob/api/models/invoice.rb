module Myob
  module Api
    module Model
      class Invoice < Base
        def model_route
          'Sale/Invoice'
        end
      end
    end
  end
end