When /^I send an Event to the Collector$/ do
  Causality::Event.cause( :event )
end
