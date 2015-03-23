module Myob
  module Api
    class Query

      attr_reader :params

      def initialize
        @params = {}
      end

      def where(options)
        @params[:where] = options.to_s
        self
      end

      def order_by(options)
        @params[:order_by] = options.to_s
        self
      end

      def limit(options)
        @params[:limit] = options.to_i
        self
      end

      def offset(options)
        @params[:offset] = options.to_i
        self
      end

    end
  end
end