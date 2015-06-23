module Myob
  module Api
    module Model
      class Tax < Base
        def model_route
          'Payroll/PayrollCategory/Tax'
        end
      end
    end
  end
end
