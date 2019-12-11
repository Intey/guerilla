extends Node2D

onready var quests = [
        Quest.new(self, "Wild Animals", 
            "Comrade, we detects many animals. You need to kill them!",
            { "type": "kill", "target": Animal, "count": "all" }, 
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

enum {
    PREVIOUS = FSM.PREVIOUS_STATE,
    IDLE,
    HAS_QUEST,
    SHOW_DETAILS,
    HAS_REWARD,
}

onready var states_map = {
    IDLE: $FSM/Idle.init(self),
    HAS_QUEST: $FSM/hasQuest.init(self),
    SHOW_DETAILS: $FSM/showDetails.init(self),
}
    
    
func _ready():
    $FSM.init(states_map, IDLE)
    for q in self.quests:
        self.add_child(q)