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
var quest_owner = null
var objectives = []
var done_objectives = []
var requirements = []
var assignee = null

var _available := false
var _done := false

signal available(quest, state)
signal completed(quest)
#for bind to UI
signal objective_done(objective)


func _init(owner, name, description, objectives, requirements=[]):
    self.quest_owner = owner
    self.quest_name = name
    self.quest_description = description
    self.requirements = requirements
    self.objectives = objectives


func _ready():
    for objective in self.objectives:
        self.add_child(objective)
        var error = objective.connect("completed", self, "on_complete_objective", [objective])
        assert(error == 0)
        
    for c in self.requirements:
        self.add_child(c)
        c.bind()
    

func is_done():
    self._done = self.objectives.empty()
    return self._done
        
    
func is_available():
    """
    Can owner take this quest to player?
    """
    if self._available:
        return true
    for condition in self.requirements:
        if not condition.meet():
            return false
        print_debug("meet condition")
    return true


#warning-ignore:unused_argument
func _process(delta):
    if self._done:
        return
    # OPTZ: timer for check 
    var new_available = self.is_available()
    # only when state changes
    if self._available != new_available:
        self._available = new_available
        emit_signal("available", self, new_available)
    if is_done():
        emit_signal("completed", self)
        
        
func on_complete_objective(objective):
    self.objectives.erase(objective)
    self.done_objectives.append(objective)
    emit_signal("objective_done", objective)
    
func assign_to(assignee):
    self.assignee = assignee
    for obj in self.objectives:
        obj.bind(assignee)
    for requirement in self.requirements:
        requirement.debind(assignee)
