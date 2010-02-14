require 'spec_helper'

describe Causality::Rule do
  before( :each ) do
    @name = "my test rule"
    @activating_causes = [ :foo, :man, :chu ]
    @resulting_effects = [ :gravity_wave, :universe_implosion ]
    @always_rule = Proc.new { |event| true }
    @never_rule = Proc.new { |event| false }
    @exceptional_rule = Proc.new{ |event| raise }
    @instance = Causality::Rule.new( @name, @activating_causes, @resulting_effects, &@always_rule )
  end

  it "should have a name attribute" do
    @instance.should respond_to( :name )
  end

  it "should have an activating_causes attribute" do
    @instance.should respond_to( :activating_causes )
  end

  it "should have an resulting_effects attribute" do
    @instance.should respond_to( :resulting_effects )
  end

  it "should have a rule attribute" do
    @instance.should respond_to( :rule )
  end

  describe "#initialize" do
    it "should set the name" do
      @instance.name.should == @name
    end

    it "should set the rule proc from the block" do
      @instance.rule.should == @always_rule
    end

    it "should set the activating_causes" do
      @instance.activating_causes.should == @activating_causes
    end

    it "should set the resulting_effects" do
      @instance.resulting_effects.should == @resulting_effects
    end
  end

  describe ".from_hash" do
    before( :each ) do
      @hash = { :name => @name,
                :activating_causes => @activating_causes,
                :resulting_effects => @resulting_effects,
                :rule => @always_rule }
      @instance = Causality::Rule.from_hash( @hash )
    end

    it "should set the name" do
      @instance.name.should == @name
    end

    it "should set the rule proc from the block" do
      @instance.rule.should == @always_rule
    end

    it "should set the activating_causes" do
      @instance.activating_causes.should == @activating_causes
    end

    it "should set the resulting_effects" do
      @instance.resulting_effects.should == @resulting_effects
    end
  end

  describe "#evaluate" do
    before( :each ) do
      @event = :some_event
    end

    it "should execute the proc with the passed event" do
      @always_rule.should_receive( :call ).with( @event ).once
      @instance.evaluate( @event )
    end

    it "should return true if the proc evaluates to true" do
      Causality::Rule.new( @name, @activating_causes, @resulting_effects, &@always_rule ).
                      evaluate( @event ).
                      should be_true
    end

    it "should return false if the proc doesn't evaluate to true" do
      Causality::Rule.new( @name, @activating_causes, @resulting_effects, &@never_rule ).
                      evaluate( @event ).
                      should be_false
    end

    it "should return false if the proc raises an exception" do
      Causality::Rule.new( @name, @activating_causes, @resulting_effects, &@exceptional_rule ).
                      evaluate( @event ).
                      should be_false
    end
  end
end
