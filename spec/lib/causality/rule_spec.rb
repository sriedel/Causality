require 'spec_helper'

describe Causality::Rule do
  it "should have a name attribute"
  it "should have an activating_causes attribute"
  it "should have an resulting_effects attribute"

  describe "#initialize" do
    it "should set the name"
    it "should set the rule proc from the block"
    it "should set the activating_causes"
    it "should set the resulting_effects"
  end

  describe "#evaluate" do
    it "should execute the proc with the passed event"
    it "should return true if the proc evaluates to true"
    it "should return false if the proc doesn't evaluate to true"
    it "should return false if the proc raises an exception"
  end
end
