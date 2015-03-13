module Myob
  module Api
    module Model
      class JournalTransaction < Base
        def model_route
          'GeneralLedger/JournalTransaction'
        end
      end
    end
  end
end
