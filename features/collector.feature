Feature: The collector collects and stores generated events
In order that events will be eventually passed to the processors,
An application using this library
Should be able to generate events and have them forwarded to an intermediate spooling store
To enable the further passing of the event downstream.

@wip
Scenario: An event is generated while the Queue is up
Given the Queue is up
When I send an Event to the Collector
Then the Event should be stored in the Queue