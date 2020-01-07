extends Node
"""
Finite state machine.
Instantiate scene FSM in target object, that need states.

```
MyObject
    |
    +- FSM
```

Create state - Node with script, that inherits states/state.gd, child of FSM.

```
MyObject
    |
    +- FSM
        |
        + - State1
        + - State2
```

Declare states as strings (constants) in target class.

```
var STATE_1 = 'state1'
var STATE_2 = 'state2'
```

Declare mapping, from state name (string contant) to state Node.
init for each state needs to accept current root node. In state it's accesible as host

```
var states = {
    STATE_1: $FSM/State1.init(self),
    STATE_2: $FSM/State2.init(self),
}
```

in _ready(), initialize FSM with created states and initial state

```
func _ready():
    $FSM.init(states, IDLE)
```

"""

class_name FSM

export var debug = false

#warning-ignore:unused_class_variable
var current_state setget , __get_current_state

var __states_stack := []

var states_map: Dictionary

const PREVIOUS_STATE = "previous"

func init(states: Dictionary, initial_state):
    if get_parent().get('debug') != null:
        self.debug = get_parent().debug or self.debug
        
    states_map = states
    assert(initial_state != null)
    states_map[initial_state].on_enter()
    __states_stack.push_back(initial_state)
        
func change_state(new_state: String, soft_transit=true):
    """
    Change current state to state. 
    soft_transit - flag, used to change state from FSM itself by it's owner. 
    It's like "direct change", that not handled by FSM, but it's owner. 
    One of cases is to simplify state changes by external events, but without 
    state cycling.
    """
    var from_state = __get_current_state()
    if new_state == null: # state not changes
        return
        
    var real_new_state = new_state
    if new_state == PREVIOUS_STATE:
        assert len(__states_stack) > 1
        real_new_state = __states_stack[-2]
    if soft_transit:
        if not self.states_map[from_state].soft_transit(real_new_state):
            return
            
    elif new_state == PREVIOUS_STATE:
        __states_stack.pop_front()
    else:
        if new_state != PREVIOUS_STATE:
            __states_stack.push_front(new_state)
    # state is changed
    if from_state != real_new_state:
        states_map[from_state].on_exit()
        states_map[real_new_state].on_enter()        
        if self.debug:
            print_debug("change state from ", from_state, " to ", __get_current_state())
    
    
func _process(delta):
    var state = states_map[__get_current_state()]
    # TODO: when states chages, handle chains of changes in one time
    var new_state = state.update(delta)
    if new_state == null:
        return
    change_state(new_state, false)
    
func _physics_process(delta):
    var state = states_map[__get_current_state()]
    state.update_physics(delta)
    
func __get_current_state():
    return __states_stack[0]