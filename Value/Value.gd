tool
extends Node

class_name Value

var value: int setget set_value, get_value
var max_value: int = 100


func _init():
    value = max_value


func set_value(nv):
    value = nv
    if value <= 0:
        value = 0
    if value >= max_value:
        value = max_value
    
    
func get_value():
    return value