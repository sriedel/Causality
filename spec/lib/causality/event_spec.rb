require 'spec_helper'

describe Causality::Event do
  before( :each ) do
    @name = :my_event
    @instance = Causality::Event.new( @name )
  end

  it "should have a class accessor to a collector instance" do
    Causality::Event.should respond_to( :collector )
  end

  it "should have a name attribute" do
    @instance.should respond_to( :name ) 
  end

  describe "the class collector accessor" do
    it "should create a collector on first access" do
      Causality::Collector.should_receive( :new ).once
      Causality::Event.collector
    end

    it "should not create a new collector on a further calls" do
      Causality::Collector.should_receive( :new ).once.
                           and_return( mock( Causality::Collector ) )
      c = Causality::Event.collector
      Causality::Event.collector.should == c
    end
  end

  describe '.cause' do
    it "should pass a newly created Event object to Causality::Collector#push" do
      Causality::Event.collector.should_receive( :push ).once.
                                 with( instance_of( Causality::Event ) )
      Causality::Event.cause( :my_event )
    end
  end

  describe ".effect" do
  end

  describe "#initialize" do
    it "should set the name" do
      @instance.name.should == @name
    end
  end

end
