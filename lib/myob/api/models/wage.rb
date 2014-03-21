module Myob
  module Api
    module Model
      class Wage < Myob::Api::Model::Base
        def model_route
          'Payroll/PayrollCategory/Wage'
        end
      end
    end
  end
end