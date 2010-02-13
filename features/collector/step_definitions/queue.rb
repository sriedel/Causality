Given /^the Queue is up$/ do
  @starling_instance = mock( Starling )
  @starling_instance.stub!( :set ).and_return { |queue, value| @to_queue, @got_value = queue, value }

  Starling.stub!( :new ).and_return( @starling_instance )
end

Then /^the Event should be stored in the Queue$/ do
  @to_queue.should == :causality_events
  @got_value.should be_a( Causality::Event )
end
