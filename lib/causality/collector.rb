module Causality
  class Collector
    attr_reader :queue
    attr_reader :spool

    RETRY_CONNECT_INTERVAL = 30

    def initialize( configfile = Causality::DEFAULT_CONFIG_FILE )
      @queue = Causality::QueueConnector::Starling.from_yml_file( configfile )
      @spool = Causality::SpoolConnector.from_yml_file( configfile )
    end

    #FIXME: make queue name configurable
    def push( event )
      begin
        if @queue.up? || @queue.seconds_down >= RETRY_CONNECT_INTERVAL 
          store_in_queue event
        else
          store_in_spool event
        end
      rescue Causality::QueueUnavailable
        store_in_spool event
      end
    end

    private
    def store_in_spool( value )
      @spool.set :causality_events, value
    end

    def store_in_queue( value )
      @queue.set :causality_events, value
    end
  end
end
