module Myob
  module Api
    module Model
      class Base

        class << self
          def all(query)
            []
          end

          def client
            @client ||= Object.new
          end

          def client=(client)
            @client = client
          end
        end

        def initialize(options)
        end

      end
    end
  end
end
