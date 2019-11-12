extends Node
class_name GameEvent

var Animal = preload("res://Animal/Animal.tscn")

func _process(delta):
    delta = GT.timespeed * delta
    self.process(delta)
    
    
var timeout = 10

func process(delta):
    if GT.time >= timeout:
        self.event()
            
func event():
    var world = get_node("/root/World")
    var ani = Animal.instance()
    var player = world.get_node("Player")
    ani.global_position = player.global_position + Vector2(50, 50)
    world.add_child(ani)
    queue_free()
    