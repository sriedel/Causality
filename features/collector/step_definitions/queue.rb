Given /^the Queue is up$/ do
  @starling_instance = mock( Starling )
  Starling.stub!( :new ).and_return( @starling_instance )
end

Then /^the Event should be stored in the Queue$/ do
  @starling_instance.should_receive( :set ).
                     with( :events, instance_of( Causality::Event ) ).
                     and_return( true )
end
