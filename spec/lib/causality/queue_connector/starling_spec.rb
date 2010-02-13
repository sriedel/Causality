require 'spec_helper'

describe Causality::QueueConnector::Starling do
  before( :each ) do
    @connection_data = { :host => "some_host", :port => 31337 }
    @starling = mock( Starling, :set => true, :get => :value )
    Starling.stub!( :new ).and_return( @starling )
    @instance = Causality::QueueConnector::Starling.new @connection_data
  end

  describe "#set" do
    context "no connection exists yet" do
      before( :each ) do
        @instance.instance_eval { @handle = nil }
      end

      it "should connect to starling" do
        Starling.should_receive( :new ).
                 once.with( "#{@connection_data[:host]}:#{@connection_data[:port]}" ).
                 and_return( @starling )
        @instance.set( :queue, :value )
        @instance.handle.should == @starling
      end

      it "should store the value in the queue" do
        @starling.should_receive( :set ).once.
                  with( :queue, :value )
        @instance.set( :queue, :value )
      end

      it "should mark the connection as up" do
        @instance.set( :queue, :value )
        @instance.status.should == :up
        @instance.down_since.should == nil
      end

    end

    context "the connection went away" do
      before( :each ) do
        @starling.stub!( :set ).and_raise( MemCache::MemCacheError )
      end

      it "should try to reconnect" do
        Starling.should_receive( :new ).
                 once.with( "#{@connection_data[:host]}:#{@connection_data[:port]}" ).
                 and_return( @starling )
        lambda { @instance.set :queue, :value }.should raise_error
      end

      it "should try to set the data again" do
        @calls = 0
        @starling.stub!( :set ).and_return { @calls += 1 ; raise }
        lambda { @instance.set :queue, :value }.should raise_error
        @calls.should == 2
      end

      context "and if after the reconnection setting still fails" do
        before( :each ) do
          @starling.stub!( :set ).and_raise( MemCache::MemCacheError )
        end

        it "should raise an exception" do
          lambda { @instance.set :queue, :value }.should raise_error  
        end

        it "should mark the queue as down" do
          lambda { @instance.set :queue, :value }.should raise_error  
          @instance.status.should == :down
          @instance.down_since.should_not be_nil
        end
      end

      context "and if reconnection succeeds" do
        before( :each ) do
          @calls = 0
          @starling.stub!( :set ).
                    and_return{ @calls += 1 ; if @calls == 1 then raise else true end }
        end

        it "should store the value in the queue" do
          @instance.set :queue, :value
        end

        it "should mark the queue as up" do
          @instance.set( :queue, :value )
          @instance.status.should == :up
          @instance.down_since.should == nil
        end
      end
    end

    context "the connection is ok" do
      before( :each ) do
        @instance.connect
      end

      it "should store the value in the queue" do
        @starling.should_receive( :set ).once.
                  with( :queue, :value )
        @instance.set( :queue, :value )
      end

    end
  end

  describe "#get" do
    context "no connection exists yet" do
      before( :each ) do
        @instance.instance_eval { @handle = nil }
      end

      it "should connect to starling" do
        Starling.should_receive( :new ).
                 once.with( "#{@connection_data[:host]}:#{@connection_data[:port]}" ).
                 and_return( @starling )
        @instance.get( :queue )
        @instance.handle.should == @starling
      end

      it "should retrieve the value from the queue" do
        @starling.should_receive( :get ).once.
                  with( :queue ).
                  and_return( :value )
        @instance.get( :queue ).should == :value
      end

    end

    context "the connection went away" do
      before( :each ) do
        @starling.stub!( :get ).and_raise( MemCache::MemCacheError )
      end

      it "should try to reconnect" do
        Starling.should_receive( :new ).
                 once.with( "#{@connection_data[:host]}:#{@connection_data[:port]}" ).
                 and_return( @starling )
        lambda { @instance.get :queue }.should raise_error
      end

      it "should try to get the data again" do
        @calls = 0
        @starling.stub!( :get ).and_return { @calls += 1 ; raise }
        lambda { @instance.get :queue }.should raise_error
        @calls.should == 2
      end

      context "and if after the reconnection getting still fails" do
        before( :each ) do
          @starling.stub!( :get ).and_raise( MemCache::MemCacheError )
        end

        it "should raise an exception" do
          lambda { @instance.get :queue }.should raise_error  
        end

        it "should mark the queue as down" do
          lambda { @instance.get :queue }.should raise_error  
          @instance.status.should == :down
          @instance.down_since.should_not be_nil
        end
      end

      context "and if reconnection succeeds" do
        before( :each ) do
          @calls = 0
          @starling.stub!( :get ).
                    and_return{ @calls += 1 ; if @calls == 1 then raise else :value end }
        end

        it "should get the value in the queue" do
          @instance.get( :queue ).should == :value
        end

        it "should mark the queue as up" do
          @instance.get( :queue )
          @instance.status.should == :up
          @instance.down_since.should == nil
        end
      end
    end

    context "the connection is ok" do
      before( :each ) do
        @instance.connect
      end

      it "should get the value in the queue" do
        @starling.should_receive( :get ).once.with( :queue ).and_return( :value )
        @instance.get( :queue ).should == :value
      end

      it "should mark the connection as up" do
        @instance.get( :queue )
        @instance.status.should == :up
        @instance.down_since.should == nil
      end

    end
  end

  describe "#connect" do
    it "should attempt to connect with a starling server identified by the connection data" do
      Starling.should_receive( :new ).once.
               with( "#{@connection_data[:host]}:#{@connection_data[:port]}" )
      @instance.connect
    end

    context "the connection was successful" do
      it "should set the handle attribute to the returned handle" do
        @instance.connect
        @instance.handle.should == @starling
      end
    end

    context "the connection failed" do
      # this shouldn't happen with starling, but who knows...
      before( :each ) do
        Starling.stub( :new ).and_raise( RuntimeError )
      end

      it "should raise an exception" do
        lambda { @instance.connect }.should raise_error( Causality::QueueUnavailable )
      end

      it "should set the handle to nil" do
        lambda { @instance.connect }.should raise_error( Causality::QueueUnavailable )
        @instance.handle.should be_nil
      end
    end
  end
end
