extends Node
class_name Blackboard

signal change_value(key, value)

var _blackboard = {}
func write(key, value):
    if _blackboard.get(key) != value:
        _blackboard[key] = value
        emit_signal("change_value", key, value)
    
func check(key):
    write(key, true)
    
func toggle(key):
    write(key, _blackboard.get('key', false))
    
func erase(key):
    _blackboard.erase(key)
    emit_signal("change_value", key, null)
    
func get(key):
    return _blackboard.get(key)