module Causality
  class Event
    attr_reader :name

    def self.collector
      @collector ||= Causality::Collector.new
    end
     
    def self.cause( *args )
      event = new( *args )
      self.collector.push event
    end

    def initialize( name )
      @name = name
    end
  end
end
