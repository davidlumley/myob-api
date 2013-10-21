class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module Myob
  module Api
    module Helpers
      def model(model_name)
        variable_name = "@#{model_name.to_s.underscore}_model".to_sym
        unless instance_variable_defined?(variable_name)
          instance_variable_set(variable_name, Myob::Api::Model.const_get("#{model_name}".to_sym).new(self, model_name.to_s))
          self.define_singleton_method("#{model_name.to_s.underscore}".to_sym) do
            instance_variable_get(variable_name)
          end
        end
        instance_variable_get(variable_name)
      end
    end
  end
end