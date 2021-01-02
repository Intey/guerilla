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
    emit_signal("change_value", _blackboard.get(key))
    
    
func uncheck(key):
    erase(key)
    
    
func toggle(key):
    var prev = _blackboard.get('key', false)
    write(key, not prev)
    emit_signal("change_value", _blackboard.get(key))
    
    
func erase(key):
    _blackboard.erase(key)
    emit_signal("change_value", _blackboard.get(key))
    
    
func get(key):
    return _blackboard.get(key)
