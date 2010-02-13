module Causality
  class Collector
    attr_reader :queue

    RETRY_CONNECT_INTERVAL = 30

    def initialize( configfile = Causality::DEFAULT_CONFIG_FILE )
      @queue = Causality::QueueConnector::Starling.from_yml_file( configfile )
    end

    #FIXME: make queue name configurable
    def push( event )
      begin
        if @queue.up? || @queue.seconds_down >= RETRY_CONNECT_INTERVAL 
          @queue.set :causality_events, event
        end
      rescue
        #TODO: store in spool
      end
    end
  end
end
