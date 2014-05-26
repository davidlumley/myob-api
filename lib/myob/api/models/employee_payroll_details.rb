module Myob
  module Api
    module Model
      class EmployeePayrollDetail < Myob::Api::Model::Base
        def model_route
          'Contact/EmployeePayrollDetails'
        end
      end
    end
  end
end