module Causality
  class Dispatcher
    attr_reader :processors
    attr_reader :filters
    attr_reader :queue
    attr_reader :subscriptions

    POLL_SLEEP_INTERVAL = 1 # seconds to sleep if no event was found 

    def initialize( configfile = Causality::DEFAULT_CONFIG_FILE )
      @queue = Causality::QueueConnector::Starling.from_yml_file( configfile )
      options = YAML.load( File.read( configfile ) )[:dispatcher]
      @filters = Causality::RuleLoader.load_directory( options[:rule_path] )
      Causality::EffectLoader.load_directory( options[:effect_path] )

      build_subscription_table
    end

    def process_loop_iteration
      event = @queue.get( :causality_events )
      return false unless event

      interested_effects = []
      subscriptions[ event.name ].each do |subscriber|
        interested_effects |= subscriber.resulting_effects if subscriber.evaluate( event )
      end

      interested_effects.each do |effect|
        Kernel.const_get( effect ).manifest( event )
      end

    end

    def process_loop
      sigterm_caught = false
      Signal.trap( "TERM" ) { sigterm_caught = true }

      loop do
        got_event = process_loop_iteration 
        break if sigterm_caught
        sleep POLL_SLEEP_INTERVAL unless got_event
      end
    end

    def build_subscription_table
      @subscriptions = {}
      @filters.each do |filter|
        filter.activating_causes.each do |cause|
          @subscriptions[cause] ||= []
          @subscriptions[cause] << filter
        end
      end
    end

  end
end
