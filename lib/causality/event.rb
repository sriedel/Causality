module Causality
  class Event
    def self.collector
      @collector ||= Causality::Collector.new
    end
     
    def self.cause( *args )
      event = new #TODO pass args
      self.collector.push event
    end
  end
end
