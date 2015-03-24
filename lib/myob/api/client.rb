module Myob
  module Api
    class Client

      extend Myob::Api::Helpers

      class << self
        def define_model_method(model_class)
          model_name = model_class.name.split('::').last
          define_method(underscore(model_name)) do
            Myob::Api::Query.new(model_class)
          end
        end
      end

      def initialize(options)
      end

    end
  end
end
