extends Node
class_name Machinary

export var debug = false

var current_state setget , __get_current_state

var __states_stack := []

var states_map: Dictionary

const PREVIOUS_STATE = 1

func init(states: Dictionary, initial_state):
    if get_parent().get('debug') != null:
        self.debug = get_parent().debug or self.debug
        
    states_map = states
    assert initial_state != null
    __states_stack.push_back(initial_state)
        


func change_state(state):
    var from_state = __get_current_state()
    if state == null: # state not changes
        return
    elif state == PREVIOUS_STATE:
        __states_stack.pop_front()
    else:
        __states_stack.push_front(state)
    if from_state != __get_current_state():
        print_debug("change state from ", from_state, " to ", __get_current_state())
    
    
func _process(delta):
    var state = states_map[__get_current_state()]
    var new_state = state.update(delta)
    #if debug and new_state != null:
        #print_debug("state ", state.name, " updates to state ", new_state)
    change_state(new_state)

func _physics_process(delta):
    pass
    
func __get_current_state():
    return __states_stack[0]