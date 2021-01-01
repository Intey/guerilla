extends Node
var inited = false
var host = null
export var debug = false
var GT = null

var GlobalTime = preload("res://World/GlobalEffects/GlobalTime.tscn")

func init(host):
    self.host = host
    inited = true
    return self
    
func _ready():
    self.GT = get_node('/root/World/GlobalTime')
    if self.GT == null:
        self.GT = GlobalTime.instance()
    if get_parent().get('debug') != null:
        self.debug = get_parent().debug or self.debug
    
func update(delta):
    assert inited and "State " + str(self) + " should be initialized with 'init'"
    
    delta = self.GT.timespeed * delta
    var new_state = self.update_impl(delta)
    if new_state:
        return new_state
    
func update_physics(delta):
    delta = self.GT.timespeed * delta
    physics_process_impl(delta)
    
func update_impl(delta):
    """
    Same as update, but delta is time lapsed by current time
    """
    
func physics_process_impl(delta):
    """
    Same as physics_update, but delta is time lapsed by current time
    """
    

func on_enter():
    """
    Executed when we transit into this state. 
    What to do:
        - connect
        - reset state of state
    """
    
    
func on_exit():
    """
    Executed when transit from this state.
    What to do:
        - disconnect from connected nodes
        - hiding some nodes, that was shown by on_enter
    """
    
    
func soft_transit(state) -> bool:
    """
    Used from FSM, for cases when we want transit by FSM or from it's parent, 
    not other states, but current state can prevent from jumping from it.
    Example is 'displayQuestDetails': user reads quest details, and if this 
    moment, some another quest become available, we jumps back to view, that 
    quest enabled.
    """
    return true