# Quest system

## What is this

It's all about having quests, assigning and finishing quests.

## What's needed

- make quests available
- coupling with events
- assign quests to player
- finish quest(by player, or by other)

Event available when it's prerequisites available - `predicate() == true`.
After available, we checks `done_predicate`, that determines finishing of quest.

When it's finished, we can get next quest. By this we can implement quest-line.

## IDEA: Manual done & Karma

Player can done quest by hands, whenever, if he get and immediatly finish
this. Commander can say "gj" but next time it's need to check is quest really
finished. If not - player is `enemy`. It's make it's available to change
"side" and relly become bad player, not just by stats. By this we get karma,
and when it's low, we marked as enemy. Karma should distribute by speaking by
npc's.

### How to check quest really done?

Common idea - tracks effects, not quest targets.
Also we need to track "i not meet time conditions". What to do, if player did
not have time?

Problem types:
- Killing someone/sometype in some place
Every unit should participate in some event, or group. Killing quests targets
preventing appears of event. So, quest owner tracks events, groups.

- Talks with someone / move info to someoune / Deliver something
Info need for starting some events. If events can't be started - drop karma.
Also, we can send "approved" unit to check, that info given. 
Or we can send one more info, with expecting, that previous info given. Target
can get integrity error, this mean that player is bustard.
One more thing: info can be needs to defence. If camp is dead - unknown state.
If camp alive - unknown state.

- Interact with something
For what? This is what we need to track.
- Burnout something

Owner needs to check, is quest really finished. HOW???
Gathering quests 
Owner should tracks it's targets. 


## Quest condition to view

Who hanlde quest condition?
Who owns availability state?

How to implement quest conditions:
- json - is dsl. Hard.
- functions - static, Needs to implement all variants. Easy boilerplate

### QuestManager - global. 
Checks all quests in world. Join Repeatable quests, manages questlines.

Issues:
- performance issues
- couple owner, quest and manager. Fix: delegate binding to quest. Quest knows
  it's parent, and which functions it's has

### Owner - local. 
Owner has quests, and checks it's conditions. 

Issues: 
- state of quest condition splitted.
- harded state binding for quest. 
- more coupling with owner and state.

### Quest - local. 
Quest know it's conditions. But it is value object. 

Issues:
- (RQ) Repeatable quests. Fix: cloning, instantiating when available. 
- (RQ) Needs to know about exist quest, and connect it to appear one by one.
- More coupling with owner and state. 
- Needs instantiate all quests, before they available. 

