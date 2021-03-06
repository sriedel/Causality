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

  it "should have a status attribute" do
    @instance.should respond_to( :status )
  end

  it "should have a down_since attribute" do
    @instance.should respond_to( :down_since )
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

    it "should set the status attribute to :unknown" do
      @instance.status.should == :unknown
    end

    it "should set the down_since attribute to nil" do
      @instance.down_since.should == nil
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

  describe "#mark_up" do
    before( :each ) do
      @instance.mark_down
      @instance.mark_up
    end

    it "should clear the down_since attribute" do
      @instance.down_since.should == nil
    end

    it "should set status to up" do
      @instance.status.should == :up
    end
  end

  describe "#mark_down" do
    before( :each ) do
      @now = Time.now
      Time.stub!( :now ).and_return( @now )
      @instance.mark_up
      @instance.mark_down
    end

    it "should set the down_since attribute to the current time" do
      @instance.down_since.should == @now 
    end

    it "should set the status to down" do
      @instance.status.should == :down
    end
  end

  describe "#up?" do
    it "should return false if the status is :down" do
      @instance.mark_down
      @instance.should_not be_up
    end

    it "should return true if the status is :up" do
      @instance.mark_up
      @instance.should be_up
    end

    it "should return true if the status is :unknown" do
      @instance.should be_true
    end
  end

  describe "#seconds_down" do
    it "should return the number of seconds since down_since if a time is stored" do
      @now = Time.now
      @instance.mark_down
      @instance.stub!( :down_since ).and_return( @now - 30 )
      @instance.seconds_down.should == 30
    end

    it "should return 0 if queue is not down" do
      @instance.mark_up
      @instance.seconds_down.should == 0
    end
  end
end
