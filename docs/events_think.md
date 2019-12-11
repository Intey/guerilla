# Global Event AI

## Event Types
TimeEvent - Event, that starts when time comes. 
ConditionalEvent - Event, that starts when conditions meets.

TimeEvent: Train start way at 02:00.
ConditionalEvent: If train not come to target destination at 12:00 - start
troops to search ways what happens.
ConditionalEvent: If Train come - join resources, and send army to enemy.

TimeEvent: Village start collect resources at 1 October 1941 06:00. At 5
October - finish collecting.

ConditionalEvent: If village has collected resources - send troop to guerillas
and send them "resources ready" message.

ConditionalEvent: If enemy detected in village - send troop to guerillas and
send them "enemy detected" message.

## Debugging

I want to see current state of each event, that runs:

- event processing - which event running at this moment
- event timeline - events order and when they starts
- event log - which event starts, when and why


## Making events "random"

Only conditional and timed events is boring. Player easy to detect this, and
hacks.

We need to create events more randomly or utility based systems. For example,
when enemy detected in village.

## Global Time and time speed

Split draw and logics. Physics looks like in logic.
With speeding up we get problem about physics: collision detection. 

## Sheduler

- Where event live, while it's not dispatched? 
- Who dispatch Conditional events and when?
- What happens, when event dispatched. Should it free or stay?
- How give owning grants from event to world?
- Who set's first, non conditional events?
- How store & run events, that has specific time?

We put sheduler in the main scene or world. Sheduler should depends on global
time, because events dispatching depends on time. 

Sheduler contains it's events, timedevent mapping, to simplify. When times come
- it's create event, and run it's process.

> How to store all events in sheduler?


It's should handle repeating, conditions, inprogress, deleting.

Repeatable model. When first iteration is finished, next is fired
```
o---|o---|o
```
Linked event model. When event done, start another.
```
o---|
     \
      o------|
```

If we store conditions in shedules, so sheduler should checks all events and
has access to all needed by event data. 
If in event - we has all event data in one piece.

Conditional model. Sheduler each delta checks conditions for all conditional
events. If condition of event is true - start event.
```
(cond == true) -> o------
```



### Long processing events
Events, that has long process.


