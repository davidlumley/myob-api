module Myob
  module Api
    module Model
      class ItemInvoice < Base
        def model_route
          'Sale/Invoice/Item'
        end
      end

      class InvoiceItem < ItemInvoice
      end
    end
  end
end
