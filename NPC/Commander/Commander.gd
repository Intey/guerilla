extends Node2D

var quests := []

# quests, that player can get
var available_quests = []

#warning-ignore:unused_class_variable
var PREVIOUS = FSM.PREVIOUS_STATE
var IDLE = "idle"
#warning-ignore:unused_class_variable
var HAS_QUEST = "has quest"
#warning-ignore:unused_class_variable
var SHOW_DETAILS = "show details"
#warning-ignore:unused_class_variable
var HAS_REWARD = "has reward"
#warning-ignore:unused_class_variable
var QUEST_OUT = "quest out"

export var debug: bool = false


onready var states_map = {
    IDLE: $FSM/Idle.init(self),
    HAS_QUEST: $FSM/hasQuest.init(self),
    SHOW_DETAILS: $FSM/showDetails.init(self),
    QUEST_OUT: $FSM/questOut.init(self),
}
    
    
func _ready():
    $FSM.init(states_map, IDLE)
    self.quests = [
        Quest.new(self, "Wild Animals", 
            "Comrade, we detects many animals. You need to kill them!",
            [KillObjective.new(Animal, 3)],
            [ObjectInArea.new(3, Animal, $View)]),
            #Quest.new(self, "More resources",
        #    "Comrade, we need more woods",
        #    { "type": "gather", "target": "sticks", "count": 10 }),
        #            
        #Quest.new(self, "Enemy Train", 
        #    "Comrade, we had bad neews. Enemies train come across our lands. "+
        #    "We need to prevent this to reacch it's destination",
        #    { "type": "stoptrain", "target": "train"})  
    ]

    for q in self.quests:
        self.add_child(q)
        assert q.connect("available", self, "on_quest_available") == 0

func on_quest_available(quest: Quest, available: bool):
    if self.debug:
        print_debug("quest ", quest.name, " available: ", available)
    if available:
        self.available_quests.append(quest)
    else:
        self.available_quests.erase(quest)