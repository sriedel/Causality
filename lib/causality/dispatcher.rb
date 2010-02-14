module Causality
  class Dispatcher
    attr_reader :processors
    attr_reader :filters

    def initialize( configfile = Causality::DEFAULT_CONFIG_FILE )
      @queue = Causality::QueueConnector::Starling.from_yml_file( configfile )
    end
  end
end
