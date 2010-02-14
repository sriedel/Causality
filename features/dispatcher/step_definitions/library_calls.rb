When /^the dispatcher despools the Event$/ do
  @dispatcher = Causality::Dispatcher.new
  @dispatcher.dispatch_loop
end

Then /^the appropriate processor\(s\) should be informed$/ do
  pending # express the regexp above with the code you wish you had
end

