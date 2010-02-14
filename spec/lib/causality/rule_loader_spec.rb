require 'spec_helper'

describe Causality::RuleLoader do
  describe ".load_directory" do
    it "should load each rule file in the given directory"
    it "should return an array of Causality::Rule objects"
    it "should skip files that cause an exception while loading"
    it "should skip files that cause an exception while creating a Causality::Rule object"
  end
end
