require 'spec_helper'

describe Causality::Collector do
  before( :each ) do
    @starling = mock( ::Starling )
    ::Starling.stub!( :new ).and_return( @starling )


    @starling_config = { :host => "some_host", :port => 31337 }
    @default_config = YAML.dump( { :queue => @starling_config } )
    File.stub!( :read ).with( Causality::DEFAULT_CONFIG_FILE ).and_return( @default_config )

    @instance = Causality::Collector.new
  end

  it "should have a queue status attribute" do
    @instance.should respond_to( :queue_status )
  end

  it "should have a queue down timestamp attribute" do
    @instance.should respond_to( :queue_down_since )
  end

  describe "#initialize" do
    context "a config yml file is passed" do
      before( :each ) do
        @other_config_file = "some_config_file"
        @other_starling_config = { :host => "other_host", :port => "73313" }
        @other_config = YAML.dump( :queue => @other_starling_config )
        File.stub!( :read ).with( @other_config_file ).and_return( @other_config )
      end

      it "should create the queue handle from the passed file" do
        Causality::QueueConnector::Starling.should_receive( :new ).once.
                                            with( @other_starling_config ).
                                            and_return( @starling )
        Causality::Collector.new( @other_config_file )
      end
    end

    context "no config file is passed" do
      it "should create the queue handle from the default configuration file" do
        Causality::QueueConnector::Starling.should_receive( :new ).once.
                                            with( @starling_config ).
                                            and_return( @starling )
        Causality::Collector.new
      end
    end

    it "should set the queue status to 'unknown'" do
      @instance.queue_status.should == :unknown
    end

    it "should set the queue_down_since attribute to nil" do
      @instance.queue_down_since.should be_nil
    end
  end

  describe "#push" do
    before( :each ) do
      @event = :event

      @now = Time.now
      Time.stub!( :now ).and_return( @now )
    end

    context "the queue is up" do
      before( :each ) do
        @starling.stub!( :set ).and_return( true )
        @instance.instance_eval { @queue_status = :up }
        @instance.instance_eval { @queue_down_since = nil }
      end

      it "should store the passed event in the queue" do
        @starling.should_receive( :set ).with( :causality_events, @event )
        @instance.push @event
      end

      it "should set the queue status to 'up'" do
        @instance.push @event
        @instance.queue_status.should == :up
      end
    end

    context "the queue just went down" do
      before( :each ) do
        @starling.stub!( :set ).and_raise( Causality::QueueUnavailable )
        @instance.instance_eval { @queue_status = :up }
        @instance.instance_eval { @queue_down_since = nil }
      end

      it "should set the queue status to 'down'" do
        @instance.push @event 
        @instance.queue_status.should == :down
      end

      it "should set the queue_down_since attribute to the current time" do
        @instance.push @event
        @instance.queue_down_since.should == @now
      end

      it "should store the event in the spool instead"
    end

    context "the queue is down" do
      before( :each ) do
        @instance.instance_eval { @queue_status = :down }
      end

      context "the queue is down for more than RETRY_CONNECT_INTERVAL seconds" do
        before( :each ) do
          down_since = @now - ( Causality::Collector::RETRY_CONNECT_INTERVAL + 1 )
          @instance.instance_eval { @queue_down_since = down_since }
        end

        it "should try to store things again in the queue" do
          @starling.should_receive( :set ).once.
                    with( :causality_events, @event ).
                    and_return( true )
          @instance.push @event
        end

        context "the queue reconnection succeeded" do
          before( :each ) do
            @starling.stub!( :set ).and_return( true )
          end

          it "should set the queue status to 'up'" do
            @instance.push @event
            @instance.queue_status.should == :up
          end

          it "should clear the queue_down_since attribute to nil" do
            @instance.push @event
            @instance.queue_down_since.should be_nil
          end
        end
      end

      context "the queue has been down for less than RETRY_CONNECT_INTERVAL seconds" do
        before( :each ) do
          down_since = @now - ( Causality::Collector::RETRY_CONNECT_INTERVAL - 1 )
          @instance.instance_eval { @queue_down_since = down_since }
        end

        it "should store the event in the spool"
        it "should not try to store the event in the queue" do
          @starling.should_not_receive( :set )
          @instance.push( @event )
        end
      end
    end
  end

end
