module Myob
  module Api
    module Model
      class Timesheet < Myob::Api::Model::Base
        def model_route
          'Payroll/Timesheet'
        end
      end
    end
  end
end