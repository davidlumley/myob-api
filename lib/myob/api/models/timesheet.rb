module Myob
  module Api
    module Model
      class Timesheet < Myob::Api::Model::Base
        def model_route
          'Payroll/Timesheet'
        end

        def new_record?(object)
          # http://developer.myob.com/api/accountright/v2/payroll/timesheet/
          # we always want to PUT timesheets, so they are never a "new" record
          false
        end
      end
    end
  end
end