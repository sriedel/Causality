Feature: The collector collects and stores generated events
In order that events will be eventually passed to the processors,
An application using this library
Should be able to generate events and have them forwarded to an intermediate spooling store
To enable the further passing of the event downstream.

Scenario: An Event is generated while the queue is up
Given we are using a Starling queue
And the queue is up
When I send an Event to the Collector
Then the Event should be stored in the Queue

Scenario: An Event is generated while the queue is down
Given we are using a Starling queue
And the queue is down
When I send an Event to the Collector
Then the Event should be stored in the Spool
