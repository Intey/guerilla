extends Area2D

var velocity = Vector2(0, 0)
export (float) var SPEED = 3000
var path_end: Vector2
var source_position: Vector2
func _ready():
    source_position = global_position

func _process(delta):
    move(delta)
    try_remove()


func move(delta):
    global_position += velocity * SPEED * delta


func try_remove():
    if $LifeTime.is_stopped():
        queue_free()
    var sp = source_position
    if path_end and (sp - global_position).length() > (sp - path_end).length():
        queue_free()
            
        