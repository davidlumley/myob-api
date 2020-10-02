module Myob
  module Api
    module Model
      class SuperannuationCategory < Base
        def model_route
          'Payroll/PayrollCategory/Superannuation'
        end
      end
    end
  end
end
