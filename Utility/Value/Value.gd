extends Node

class_name Value

export var max_value: int = 100
export var min_value: int = 0
var value: float setget set_value, get_value

signal value_changed(prev_value, current_value)

func _init():
    value = max_value


func set_value(nv: float):
    var prev_value = value
    value = nv
    if value <= 0:
        value = 0
    if value >= max_value:
        value = max_value
    emit_signal("value_changed", prev_value, value)
    
func get_value():
    return value
    
func change(diff: float):
    var prev_value = get_value()
    set_value(prev_value + diff)
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
