extends Node
var utils = preload("res://Utility/utils.gd").new()

var current_state = null
var __states_stack := []
var states_map: Dictionary

func _init(states: Dictionary):
    states_map = states

func change_state(state):
    if state == null: # to previous
        __states_stack.pop_front()
    else:
        __states_stack.push_front(state)
    current_state = __states_stack[0]
    
func update(delta):
    utils.throttle_print(delta, ["update machinary:", current_state])
    var new_state = states_map[current_state].update(delta)
    utils.throttle_print(delta, ["update machinary new state:", new_state])
    if new_state:
        return change_state(new_state)