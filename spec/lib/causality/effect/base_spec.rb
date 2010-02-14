require 'spec_helper'

describe Causality::Effect::Base do
  before( :each ) do
    @name = :effect_name
    @instance = Causality::Effect::Base.new( @name )
  end

  it "should have a name attribute" do
    @instance.should respond_to( :name )
  end

  describe "#initialize" do
    it "should assign the name attribute" do
      @instance.name.should == @name
    end
  end
end
