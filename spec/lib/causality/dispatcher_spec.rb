require 'spec_helper'

describe Causality::Dispatcher do
  before( :each ) do
    @queue_data = { :host => "host", :port => "31337" }
    @dispatcher_data = {}
    @options = { :queue => @queue_data, :dispatcher => @dispatcher_data }

    File.stub!( :read ).with( Causality::DEFAULT_CONFIG_FILE ).and_return( YAML.dump( @options ) )

    @instance = Causality::Dispatcher.new
  end

  it "should have a processors attribute" do
    @instance.should respond_to( :processors )
  end

  it" should have a filters attribute" do
    @instance.should respond_to( :filters )
  end

  describe "#initialize" do
    it "should load the processors"
    it "should load the subscription filters"

    context "a configuration file was passed" do
      before( :each ) do
        @other_queue_options = { :host => "other_host", :port => "12345" }
        @other_dispatcher_options = {}
        @other_options = { :queue => @other_queue_options, 
                           :dispatcher => @other_dispatcher_options }

        @configfile = "some_config_file"
        File.stub!( :read ).with( @configfile ).and_return( YAML.dump( @other_options ) )
      end

      it "should get a queue handle from the configuration file" do
        Causality::QueueConnector::Starling.should_receive( :new ).once.
                                            with( @other_queue_options )
        Causality::Dispatcher.new( @configfile )
      end
    end

    context "no configuration file was passed" do
      it "should get a queue handle from the default configuration file" do
        Causality::QueueConnector::Starling.should_receive( :new ).once.
                                            with( @queue_data )
        Causality::Dispatcher.new
      end
    end
  end

  describe "#process_loop" do
    it "should despool an event"
    context "if it got an event" do
      it "should send the event to all interested subscribers"
      it "should not send the event to uninterested subscribers"
    end
    context "if it didn't get an event" do
      it "should sleep POLL_INTERVAL seconds and then try again"
    end
    context "if it catches a SIGTERM" do
      it "should stop processing after the current iteration and exit"
    end
  end
end
