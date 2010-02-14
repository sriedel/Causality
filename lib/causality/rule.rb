module Causality
  class Rule
    attr_reader :name
    attr_reader :activating_causes
    attr_reader :resulting_effects
    attr_reader :rule

    def initialize( name, activating_causes, resulting_effects, &rule )
      @name = name
      @activating_causes = activating_causes
      @resulting_effects = resulting_effects
      @rule = rule
    end

    def self.from_hash( options )
      new options[:name], 
          options[:activating_causes], 
          options[:resulting_effects], 
          &options[:rule]
    end

    def evaluate( event )
      @rule.call( event ) rescue false
    end
  end
end
