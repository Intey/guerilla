extends Node

var _blackboard = {}
func write(key, value):
    _blackboard[key] = value
    
func check(key):
    _blackboard[key] = true
    
func toggle(key):
    _blackboard[key] = not _blackboard[key]
    
func erase(key):
    _blackboard.erase(key)
    
func get(key):
    return _blackboard.get(key)