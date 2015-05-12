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

        def models
          @models ||= ObjectSpace.each_object(Class).select{|klass| klass < Myob::Api::Model::Base}
        end
      end


      ###
      # sets up methods to allow access to models via client
      #
      models.each do |model_class|
        Myob::Api::Client.define_model_method(model_class)
      end

      def initialize(options)
        Myob::Api::Client.models.each do |model_class|
          setup_model_client(model_class)
        end
      end

      ###
      # sets up models to allow them to use the client for API calls
      #
      def setup_model_client(model_class)
        model_class.client = self
      end

    end
  end
end
