extends Node
class_name Quest

# we need owner. Some NPC that owns a quest, and contains all processing
# functions, links, targets, etc. For example, Commander has visibility area,
# and detects animals. When it's detects 4 animals - it can take quest.

# We need to store it there, because we need to transfer this object from one
# owner to player. When transfering, we need to save info about:
# - who gives as this quest
# - it quest is gotten by player

var quest_name: String
var quest_description: String
var quest_owner
var player_gets := true
var objectives = []
var done_objectives = []
var available_conditions = []

var available := false
var quest_done := false

signal available(state)
#for bind to UI
signal objective_done(objective)


func _init(owner, name, description, objectives, available_conditions):
    self.quest_owner = owner
    self.quest_name = name
    self.quest_description = description
    self.available_conditions = available_conditions
    self.objectives = objectives


func _ready():
    for objective in self.objectives:
        objective.connect("completed", self, "on_complete_objective", [objective])
    

func is_done():
    return self.objectives.size() == 0
        
    
func is_available():
    """
    Can owner take this quest to player?
    """
    if self.available:
        return true
    for condition in self.available_conditions:
        if not condition.meet():
            return false
    return true


func _process(delta):
    # OPTZ: timer for check 
    var new_available = self.is_available()
    # only when state changes
    if self.available != new_available:
        self.available = new_available
        emit_signal("available", new_available)
        
        
func on_complete_objective(objective):
    self.objectives.erase(objective)
    self.done_objectives.append(objective)
    emit_signal("objective_done", objective)
    