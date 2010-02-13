require 'spec_helper'

describe Causality::QueueConnector::Base do
  class DemoQueue < Causality::QueueConnector::Base 
  end

  before( :each ) do
    @instance = DemoQueue.new
  end

  it "should have a handle attribute" do
    @instance.should respond_to( :handle )
  end

  describe ".from_yml_file" do
    it "should read the passed filename"
    it "should default to the hardcoded default"
    it "should call initialize with the parsed YAML in the queue section"
  end

  describe "#initialize" do
    it "should store the passed hostname"
    it "should store the passed port"
  end

  describe "#connect" do
  end

  describe "#set" do
  end

  describe "#get" do
  end
end
