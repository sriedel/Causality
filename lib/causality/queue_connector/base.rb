module Causality
  module QueueConnector
    class Base
      attr_reader :handle
      attr_reader :connection_data
      attr_reader :status
      attr_reader :down_since

      def self.from_yml_file( filename = Causality::DEFAULT_CONFIG_FILE )
        new YAML.load( File.read( filename ) )[:queue]
      end

      def initialize( options )
        @connection_data = { :host => options[:host],
                             :port => options[:port] }
        @status = :unknown
      end

      def mark_up
        @status = :up
        @down_since = nil
      end

      def mark_down
        @down_since = Time.now
        @status = :down
      end

      def connect
        raise "I'm part of an abstract class. Override me!"
      end

      def set
        raise "I'm part of an abstract class. Override me!"
      end

      def get
        raise "I'm part of an abstract class. Override me!"
      end
    end
  end
end
