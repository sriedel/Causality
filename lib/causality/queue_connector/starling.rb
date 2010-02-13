require 'starling'

module Causality
  module QueueConnector
    class Starling < Causality::QueueConnector::Base
      def set( queue, data )
        try_with_reconnect { @handle.set queue, data }
      end

      def get( queue )
        try_with_reconnect{ @handle.get queue }
      end

      def connect
        @handle = ::Starling.new connection_string
      rescue
        @handle = nil
        raise Causality::QueueUnavailable
      end

      private
      def connection_string
        [ @connection_data[:host], @connection_data[:port].to_s ].join( ":" )
      end

      def try_with_reconnect
        tries = 0
        begin 
          connect unless @handle
          yield

        rescue
          raise $! if tries > 0

          tries += 1
          retry
        end
      end
    end
  end
end
