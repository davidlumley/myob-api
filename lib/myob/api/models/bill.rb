module Myob
  module Api
    module Model
      class Bill < Base
        def model_route
          'Purchase/Bill'
        end
      end
    end
  end
end