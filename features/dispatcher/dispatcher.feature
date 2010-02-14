Feature: The dispatcher dequeues events and notifies subscribers 
In order that all interested processors can process the event
The dispatcher
Should be able to dequeue events and notify subscribers
To enable the final processing of the events.

Scenario: An Event is queued
Given we are using a Starling queue
And the Starling server is up
And an Event is queued
When the dispatcher despools the Event
Then the appropriate processor(s) should be informed
