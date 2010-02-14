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

    def evaluate( event )
      @rule.call( event ) rescue false
    end
  end
end
