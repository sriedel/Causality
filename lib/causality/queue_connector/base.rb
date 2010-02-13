module Causality
  module QueueConnector
    class Base
      attr_reader :handle
      attr_reader :connection_data

      def self.from_yml_file( filename = Causality::DEFAULT_CONFIG_FILE )
        new YAML.load( File.read( filename ) )[:queue]
      end

      def initialize( options )
        @connection_data = { :host => options[:host],
                             :port => options[:port] }
      end
    end
  end
end
