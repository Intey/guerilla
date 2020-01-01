extends Node2D

#warning-ignore:unused_class_variable
export var debug: bool = false

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

var current_quest: Quest = null

#warning-ignore:unused_signal
signal quest_available(quest, available)
    
    
onready var states_map = {
    IDLE: $FSM/Idle.init(self),
    HAS_QUEST: $FSM/hasQuest.init(self),
    SHOW_DETAILS: $FSM/showDetails.init(self),
    QUEST_OUT: $FSM/questOut.init(self),
    HAS_REWARD: $FSM/hasReward.init(self),
}
    
    
func _ready():
    $FSM.init(states_map, IDLE)
    questManager.add_quest( 
        Quest.new(self, "Wild Animals", 
            "Comrade, we detects many animals. You need to kill them!",
            [KillObjective.new(Animal, 3)],
            [ObjectInArea.new(3, Animal, $View)]))
    questManager.add_quest(
        Quest.new(self, "More sticks",
        "Comrade, collest sticks",
        [GatherObjective.new(ResourceStick, 2)]))
    
# Quest Giver Component
func assign_current_quest():
    """
    Curent quest, that player currently view
    """
    # Looks like a hack. 
    questManager.assign_quest(self.current_quest, $'/root/World/Player')
    self.current_quest = null
    
    
func reward():
    var quests = questManager.get_reward_quests(self)
    print_debug("reward with assigned quest", quests[0])
    questManager.reward(quests[0])
    
    
func has_quest():
    return not questManager.get_available_quests(self).empty()


func has_reward():
    return not questManager.get_reward_quests(self).empty()
    
    
func display_quest():
    var quests = questManager.get_available_quests(self)
    self.current_quest = quests[0]
    