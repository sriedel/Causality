require 'spec_helper'

describe Causality::QueueConnector::Base do
  class DemoQueue < Causality::QueueConnector::Base 
  end

  before( :each ) do
    @connection_data = { :host => "some_host",
                         :port => 31337 }
    @instance = DemoQueue.new @connection_data
  end

  it "should have a handle attribute" do
    @instance.should respond_to( :handle )
  end

  it "should have a connection_data attribute" do
    @instance.should respond_to( :connection_data )
  end

  describe ".from_yml_file" do
    before( :each ) do
      @filename = "some_file.yml"
      @yml_data = YAML.dump( { :queue => @connection_data } )
      File.stub!( :read ).and_return( @yml_data )
    end

    it "should read the passed filename" do
      File.should_receive( :read ).with( @filename ).and_return( @yml_data )
      DemoQueue.from_yml_file( @filename )
    end

    it "should default to the hardcoded default" do
      File.should_receive( :read ).with( Causality::DEFAULT_CONFIG_FILE ).
           and_return( @yml_data )
      DemoQueue.from_yml_file
    end

    it "should call initialize with the parsed YAML in the queue section" do
      instance = DemoQueue.from_yml_file
      instance.connection_data.should == @connection_data
    end

    it "should return a QueueConnector instance" do
      DemoQueue.from_yml_file( "some_file" ).should be_a( DemoQueue )
    end
  end

  describe "#initialize" do
    it "should store the passed hostname" do
      @instance.connection_data[:host] = @connection_data[:host]
    end

    it "should store the passed port" do
      @instance.connection_data[:port] = @connection_data[:port]
    end
  end

  describe "#connect" do
    before( :each ) do
      @method = :connect
    end

    it_should_behave_like "an abstract method"
  end

  describe "#set" do
    before( :each ) do
      @method = :set
    end
    
    it_should_behave_like "an abstract method"
  end

  describe "#get" do
    before( :each ) do
      @method = :get
    end

    it_should_behave_like "an abstract method"
  end
end
