require 'starling'

module Causality
  module QueueConnector
    class Starling < Causality::QueueConnector::Base
      def set( queue, data )
        tries = 0
        begin
          connect unless @handle
          @handle.set queue, data
        rescue
          raise $! if tries > 0

          tries += 1
          retry
        end
      end

      def get( queue )
        tries = 0
        begin 
          connect unless @handle
          @handle.get queue
        rescue
          raise $! if tries > 0

          tries += 1
          retry
        end
      end

      def connect
        @handle = ::Starling.new "some_host:31337" #connection_string
      rescue
        @handle = nil
        raise Causality::QueueUnavailable
      end

      private
      def connection_string
        [ @connection_data[:host], @connection_data[:port].to_s ].join( ":" )
      end
    end
  end
end
