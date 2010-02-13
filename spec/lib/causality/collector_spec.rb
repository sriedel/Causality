require 'spec_helper'

describe Causality::Collector do
  before( :each ) do
    @starling = mock( ::Starling )
    ::Starling.stub!( :new ).and_return( @starling )

    @spool = mock( ::SpoolPool::Pool, :put => true )
    ::SpoolPool::Pool.stub!( :new ).and_return( @spool )

    @starling_config = { :host => "some_host", :port => 31337 }
    @spool_config = { :spool_path => '/some/spool/path' }

    @default_config = YAML.dump( { :queue => @starling_config,
                                   :spool => @spool_config } )
    File.stub!( :read ).with( Causality::DEFAULT_CONFIG_FILE ).and_return( @default_config )

    @instance = Causality::Collector.new
  end

  describe "#initialize" do
    context "a config yml file is passed" do
      before( :each ) do
        @other_config_file = "some_config_file"
        @other_starling_config = { :host => "other_host", :port => "73313" }
        @other_spool_config = { :spool_path => '/some/other/path' }
        @other_config = YAML.dump( :queue => @other_starling_config,
                                   :spool => @other_spool_config )
        File.stub!( :read ).with( @other_config_file ).and_return( @other_config )
      end

      it "should create the queue handle from the passed file" do
        Causality::QueueConnector::Starling.should_receive( :new ).once.
                                            with( @other_starling_config ).
                                            and_return( @starling )
        Causality::Collector.new( @other_config_file )
      end

      it "should create a spool handle from the passed file" do
        Causality::SpoolConnector.should_receive( :new ).once.
                                  with( @other_spool_config ).
                                  and_return( @spool )
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

      it "should create a spool handle from the default configuration file" do
        Causality::SpoolConnector.should_receive( :new ).once.
                                  with( @spool_config ).
                                  and_return( @spool )
        Causality::Collector.new
      end
    end
  end

  describe "#push" do
    before( :each ) do
      @event = :event
    end

    context "the queue is up" do
      before( :each ) do
        @starling.stub!( :set ).and_return( true )
      end

      it "should store the passed event in the queue" do
        @starling.should_receive( :set ).with( :causality_events, @event )
        @instance.push @event
      end
    end

    context "the queue just went down" do
      before( :each ) do
        @starling.stub!( :set ).and_raise( Causality::QueueUnavailable )
      end

      it "should store the event in the spool instead" do
        @spool.should_receive( :put ).with( :causality_events, @event )
        @instance.push @event
      end
    end

    context "the queue is down" do
      before( :each ) do
        @instance.queue.mark_down
      end

      context "the queue is down for more than RETRY_CONNECT_INTERVAL seconds" do
        before( :each ) do
          seconds = Causality::Collector::RETRY_CONNECT_INTERVAL + 1 
          @instance.queue.stub!( :seconds_down ).and_return( seconds )
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

          it "should not store the event in the spool" do
            @spool.should_not_receive( :put )
            @instance.push @event
          end
        end

        context "the queue reconnection didn't succeed" do
          before( :each ) do
            @starling.stub!( :set ).and_raise( Causality::QueueUnavailable )
          end

          it "should store the event in the spool" do
            @spool.should_receive( :put ).with( :causality_events, @event )
            @instance.push @event
          end
        end
      end

      context "the queue has been down for less than RETRY_CONNECT_INTERVAL seconds" do
        before( :each ) do
          seconds = Causality::Collector::RETRY_CONNECT_INTERVAL - 1 
          @instance.queue.stub!( :seconds_down ).and_return( seconds )
        end

        it "should store the event in the spool" do
          @spool.should_receive( :put ).with( :causality_events, @event )
          @instance.push @event
        end

        it "should not try to store the event in the queue" do
          @starling.should_not_receive( :set )
          @instance.push( @event )
        end
      end
    end
  end

end
