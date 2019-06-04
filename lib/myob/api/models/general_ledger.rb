module Myob
  module Api
    module Model
      class GeneralLedger < Base
        def model_route
          'GeneralLedger'
        end
      end

      class Account < Base
        def model_route
          'GeneralLedger/Account'
        end
      end

      class AccountBudget < Base
        def model_route
          'GeneralLedger/AccountBudget'
        end
      end

      class AccountingProperties < Base
        def model_route
          'GeneralLedger/AccountingProperties'
        end
      end

      class AccountRegister < Base
        def model_route
          'GeneralLedger/AccountRegister'
        end
      end

      class Category < Base
        def model_route
          'GeneralLedger/Category'
        end
      end

      class CategoryRegister < Base
        def model_route
          'GeneralLedger/CategoryRegister'
        end
      end

      class Currency < Base
        def model_route
          'GeneralLedger/Currency'
        end
      end

      class GeneralJournal < Base
        def model_route
          'GeneralLedger/GeneralJournal'
        end
      end

      class Job < Base
        def model_route
          'GeneralLedger/Job'
        end
      end

      class JobBudget < Base
        def model_route
          'GeneralLedger/JobBudget'
        end
      end

      class JobRegister < Base
        def model_route
          'GeneralLedger/JobRegister'
        end
      end

      class JournalTransaction < Base
        def model_route
          'GeneralLedger/JournalTransaction'
        end
      end

      class LinkedAccount < Base
        def model_route
          'GeneralLedger/LinkedAccount'
        end
      end

      class TaxCode < Base
        def model_route
          'GeneralLedger/TaxCode'
        end
      end
    end
  end
end
