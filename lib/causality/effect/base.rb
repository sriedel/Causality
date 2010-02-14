module Causality
  module Effect
    class Base
      attr_reader :name

      def initialize( name )
        @name = name
      end
    end
  end
end
