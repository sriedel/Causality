class MockStarling
  attr_reader :up

  def up!
    @up = true
  end

  def down!
    @up = false
  end

  def initialize
    @queues = {}
  end

  def set( queue, value )
    raise Causality::QueueUnavailable unless @up
    @queues[queue] ||= []
    @queues[queue] << value
  end

  def get( queue )
    @queues[queue] ||= []
    @queues[queue].shift
  end
end

Given /^we are using a Starling queue$/ do
  @starling = MockStarling.new
  Starling.stub!( :new ).and_return( @starling )
end

Given /^the Starling server is up$/ do
  @starling.up!
end

Given /^the Starling server is down$/ do
  @starling.down!
end


Then /^the Event should be stored in the Queue$/ do
  value = @starling.get :causality_events
  value.should be_a( Causality::Event )
end
