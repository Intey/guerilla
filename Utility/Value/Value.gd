extends Node

class_name Value

export var max_value: int = 100
export var min_value: int = 0
export var initial_value: int = 100
export var debug: bool = false

var value: float setget set_value, get_value

signal value_changed(prev_value, current_value)


func _ready():
    if debug:
        print_debug("Value: initialize with: ", initial_value)
    value = initial_value


func set_value(nv: float):
    var prev_value = value
    value = nv
    if value <= 0:
        value = 0
    if value >= max_value:
        value = max_value
    if self.debug:
        print_debug("Value.set_value(", nv, ")")
    emit_signal("value_changed", prev_value, value)
    
func get_value():
    return value
    
func change(diff: float):
    var prev_value = get_value()
    set_value(prev_value + diff)
    if self.debug:
        print_debug(
            "value_changed: "
            , self.name
            , " from "
            , prev_value
            , " to "
            , value
            , " with ", diff
            )
    emit_signal("value_changed", prev_value, value)
