require 'starling'

module Causality
  module QueueConnector
    class Starling < Causality::QueueConnector::Base
      def set( queue, data )
        try_with_reconnect { @handle.set( queue, data ) }
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
        value = nil
        begin 
          connect unless @handle
          value = yield

        rescue MemCache::MemCacheError
          if tries > 0
            mark_down
            raise Causality::QueueUnavailable
          end

          tries += 1
          retry
        else
          mark_up
        end
        value
      end
    end
  end
end
