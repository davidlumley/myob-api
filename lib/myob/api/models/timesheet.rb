module Myob
  module Api
    module Model
      class Timesheet < Myob::Api::Model::Base
        def model_route
          'Payroll/Timesheet'
        end

        def date_fields
          ['StartDate', 'EndDate']
        end

        # http://developer.myob.com/api/accountright/v2/payroll/timesheet/
        # we always want to PUT timesheets, so they are never a "new" record
        def new_record?(object)
          false
        end

        # a timesheet is identified based on an employee UID as well as its start and end date
        # it does not have a UID of its own
        def url(object = nil)
          if object
            "#{super()}/#{object['Employee']['UID']}?StartDate=#{object['StartDate']}&EndDate=#{object['EndDate']}"
          else
            super
          end
        end
      end
    end
  end
end