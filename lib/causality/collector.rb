module Causality
  class Collector
    attr_reader :queue_status #TODO: move this to the queue class
    attr_reader :queue_down_since # TODO: move this to the queue connector

    RETRY_CONNECT_INTERVAL = 30

    def initialize( configfile = Causality::DEFAULT_CONFIG_FILE )
      @queue_status = :unknown
      @queue = Causality::QueueConnector::Starling.from_yml_file( configfile )
    end

    #FIXME: make queue name configurable
    def push( event )
      begin
        if ( Time.now - @queue_down_since.to_i ).to_i >= RETRY_CONNECT_INTERVAL 
          @queue.set :causality_events, event
        end
      rescue
        @queue_status = :down
        @queue_down_since = Time.now
        #TODO: store in spool
      else
        @queue_status = :up
        @queue_down_since = nil
      end
    end
  end
end
