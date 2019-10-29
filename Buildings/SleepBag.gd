extends Node2D


func _process(delta):
    var mp = get_global_mouse_position()
    

func _on_Area2D_body_entered(body):
    if body is Player:
        body.set_sleep_zone()


func _on_Area2D_body_exited(body):
    if body is Player:
        body.set_sleep_zone(false)
