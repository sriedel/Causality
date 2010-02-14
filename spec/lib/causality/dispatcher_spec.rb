require 'spec_helper'

describe Causality::Dispatcher do
  before( :each ) do
    project_root = File.expand_path( File.join( '..', '..', '..', 'test_rules' ),
                                     File.dirname( __FILE__ ) )

    @queue_data = { :host => "localhost", :port => 22122 }
    @dispatcher_data = { :rule_path => File.join( project_root, 'test_rules' ),
                         :effect_path => File.join( project_root, 'test_effects' ) }
    @options = { :queue => @queue_data, :dispatcher => @dispatcher_data }


    @instance = Causality::Dispatcher.new
  end

  it "should have a processors attribute" do
    @instance.should respond_to( :processors )
  end

  it" should have a filters attribute" do
    @instance.should respond_to( :filters )
  end

  it "should have a subscriptions attribute" do
    @instance.should respond_to( :subscriptions )
  end

  describe "#initialize" do
    it "should load the effects" do
      Kernel.const_defined?( :Rapture ).should be_true
    end

    it "should load the subscription filters" do
      @instance.filters.should_not be_nil
    end

    it "should build the subscription table" do
      @instance.subscriptions.should be_a( Hash )
    end

    context "a configuration file was passed" do
      before( :each ) do
        @other_queue_options = { :host => "other_host", :port => "12345" }
        @other_dispatcher_options = { :rule_path => 'test_rules', 
                                      :effect_path => 'test_effects' }
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

  describe "#process_loop_iteration" do
    before( :each ) do
      @event = Causality::Event.new( :gravity_wave )
    end

    it "should despool an event" do
      @instance.queue.should_receive( :get ).with( :causality_events ).and_return( @event )
      @instance.process_loop_iteration
    end

    context "if it got an event" do 
      before( :each ) do
        @instance.queue.stub!( :get ).and_return( @event )
      end

      it "should send the event to all interested subscribers" do
        Rapture.should_receive( :manifest ).with( @event ).any_number_of_times
        Sublimation.should_receive( :manifest ).with( @event ).any_number_of_times
        @instance.process_loop_iteration
      end

      it "should not send the event twice to any interested subscriber" do
        Rapture.should_receive( :manifest ).with( @event ).once
        Sublimation.should_receive( :manifest ).with( @event ).once
        @instance.process_loop_iteration
      end

      it "should not send the event to uninterested subscribers" do
        Damnation.should_not_receive( :manifest )
        Hellfire.should_not_receive( :manifest )
      end
    end
  end

  describe "#build_subscription_table" do
    before( :each ) do
      @instance.build_subscription_table
    end

    it "should build the subscriptions hash" do
      @instance.subscriptions.should be_a( Hash )
    end

    it "should key by cause" do
      @instance.subscriptions.keys.sort.should == [ :gravity_wave, :universe_implosion ].sort
    end

    it "should have arrays of filters with the keyed activation_causes as values" do
      rules = @instance.subscriptions[:gravity_wave].collect { |r| r.name }
      rules.should include( "always true" )
      rules.should include( "always false" )
      rules.should include( "lethargic" )
      rules.should include( "exceptional" )
    end

    it "should not have uninterested filters in the arrays" do
      rules = @instance.subscriptions[:gravity_wave].collect{ |r| r.name }
      rules.should_not include( "uninterested" )
    end
  end
end
