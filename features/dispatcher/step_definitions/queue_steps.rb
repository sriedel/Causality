Given /^an Event is queued$/ do
  @queued_event = Causality::Event.new
  @starling.set :causality_events, @queued_event
end

