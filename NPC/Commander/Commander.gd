extends Node2D

var quests := []

# quests, that player can get
var available_quests = []

enum {
    PREVIOUS = FSM.PREVIOUS_STATE,
    IDLE,
    HAS_QUEST,
    SHOW_DETAILS,
    HAS_REWARD,
    QUEST_OUT,
}

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
        q.connect("available", self, "on_quest_available", [q])

func on_quest_available(quest: Quest, available: bool):
    if available:
        self.available_quests.append(quest)
    else:
        self.available_quests.erase(quest)