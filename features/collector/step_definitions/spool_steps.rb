Then /^the Event should be stored in the Spool$/ do
  value = Causality::Event.collector.spool.get :causality_events
  value.should be_a( Causality::Event )
end

