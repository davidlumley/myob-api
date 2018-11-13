module Myob
    module Api
      module Model
        class InventoryAdjustment < Base
          def model_route
            'Inventory/Adjustment'
          end
        end
          
        class InventoryItems < Base
          def model_route
            'Inventory/Item'
          end
        end  
      end
    end
  end
