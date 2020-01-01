extends Node
class_name ObjectInArea

var count: int
var _type
var area: Area2D
var debug: bool

var _state_count: int = 0


func _init(count: int, type, area, debug=false):
    self.name = "ObjectInArea"
    
    self.count = count
    self._type = type
    self.area = area
    self.debug = debug
    if self.debug:
        print_debug(self.name, " tracks ", self._type, " in ", self.area)
    
func bind():
    self.area.connect("body_entered", self, "on_enters")
    self.area.connect("body_exited", self, "on_exit")
    
    
func debind():
    self.area.disconnect("body_entered", self, "on_enters")
    self.area.disconnect("body_exited", self, "on_exit")
    
    
func meet():
    var result = _state_count >= self.count
    if self.debug and result:
        print_debug("meet condition ", self.name)
    return result
     
    
func on_enters(body):
    if self.debug:
        print_debug(self.name, " detects body: ", body)
    if body is self._type:
        if self.debug:
            print_debug(self.name, " body matched type")
        self._state_count += 1
        
func on_exit(body):
    if body is self._type:
        self._state_count -= 1