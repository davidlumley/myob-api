module Myob
  module Api
    module Model
      class InvoiceItem < Myob::Api::Model::Base
        def model_route
          'Sale/Invoice/Item'
        end
      end
    end
  end
end