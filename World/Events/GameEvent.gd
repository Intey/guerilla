extends Node
class_name GameEvent

export var timeout = 10
var wait_sec = 0
var appears = false
var GT: GlobalTime


func _ready():
    GT = get_node('/root/World/GlobalTime')
    assert(GT != null)


func _process(delta):
    delta = GT.timespeed * delta
    self.process(delta)
    

func process(delta):
    if self.appears:
        self.wait_sec += delta
        if self.wait_sec >= timeout:
            print_debug("event fire: ", self.name, " at ", GT.time)
            self.event()
            self.appears = false
    
    
func appear():
    assert(GT != null)
    print_debug("appears event: ", self.name, " at ", GT.time)
    self.appears = true


var Animal = preload("res://Animal/Animal.tscn")
            
            
func event():
    var world = get_node("/root/World")
    var ani = Animal.instance()
    var player = world.get_node("Player")
    ani.global_position = player.global_position + Vector2(50, 50)
    world.add_child(ani)
    queue_free()
    