require 'spec_helper'

describe Causality::EffectLoader do
  describe ".load_directory" do
    before( :each ) do
      @effect_directory = "test_effects"
    end

    it "should require all effects from the directory" do
      Causality::EffectLoader.load_directory( @effect_directory )
      Kernel.const_defined?( :TestEffect ).should be_true
    end

    it "should gracefully deal with the effect files that cause an exception on require" do
      lambda { Causality::EffectLoader.load_directory( @effect_directory ) }.should_not raise_error 
    end
  end
end
