extends Node
class_name ObjectInArea

var count: int
var type
var area: Area2D

var _state_count: int = 0


func _init(count: int, type, area):
    self.count = count
    self.type = type
    self.area = area
    
    
func bind():
    self.area.connect("body_shape_entered", self, "on_enters")
    self.area.connect("body_shape_exited", self, "on_exit")
    
    
func debind():
    self.area.disconnect("body_shape_entered", self, "on_enters")
    self.area.disconnect("body_shape_exited", self, "on_exit")
    
    
func meet():
    return _state_count >= self.count
     
    
func on_enters(body):
    if body is self.type:
        self._state_count += 1
        
func on_exit(body):
    if body is self.type:
        self._state_count -= 1