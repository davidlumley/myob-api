module Myob
  module Api
    module Model
      class PayrollCategory < Myob::Api::Model::Base
        def model_route
          'Payroll/PayrollCategory'
        end
      end
    end
  end
end