require 'spec_helper'

describe Causality::RuleLoader do
  before( :each ) do
    @test_rule_path = Pathname.new( 'test_rules' )
    @test_rule_file = @test_rule_path + 'my_rules.rb' 
    @other_rule_file = @test_rule_path + 'other_rules.rb' 
    @loading_exception_rule_file = @test_rule_path + 'loading_exception_rules.rb' 
  end

  describe ".load_directory" do
    it "should load the rules in each rule file in the given directory" do
      array = Causality::RuleLoader.load_directory( @test_rule_path.to_s )
      array.size.should == 5
    end

    it "should return an array of Causality::Rule objects" do
      array = Causality::RuleLoader.load_directory( @test_rule_path.to_s )
      array.each { |rule| rule.should be_a( Causality::Rule ) }
    end

    it "should skip files that cause an exception while loading" do
      lambda { Causality::RuleLoader.load_directory( @test_rule_path.to_s ) }.should_not raise_error
    end

    it "should skip rules that cause an exception while creating a Causality::Rule object" 
  end

  describe ".load_file" do
    it "should load the rules in each rule file in the given directory" do
      Causality::RuleLoader.load_file( @test_rule_file.to_s ).size.should == 2
    end

    it "should return an array of Causality::Rule objects" do
      Causality::RuleLoader.load_file( @test_rule_file.to_s ).each do |rule|
        rule.should be_a( Causality::Rule ) 
      end
    end

    it "should skip files that cause an exception while loading" do
      lambda { Causality::RuleLoader.load_file( @test_rule_file.to_s ) }.should_not raise_error
    end

    it "should skip rules that cause an exception while creating a Causality::Rule object" 

  end

end
