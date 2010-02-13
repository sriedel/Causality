class MockSpool
  def initialize
    @queues = {}
  end

  def put( queue, value )
    @queues[queue] ||= []
    @queues[queue] << value
  end

  def get( queue )
    @queues[queue] ||= []
    @queues[queue].shift
  end
end

Given /^an Event is generated$/ do
  @spool = MockSpool.new
  SpoolPool::Pool.stub!( :new ).and_return( @spool )

  # reset collector because otherwise the starling handle is cached
  # and we can't switch between up and down
  Causality::Event.instance_eval { @collector = nil }
end

When /^I send an Event to the Collector$/ do
  Causality::Event.cause( :event )
end
