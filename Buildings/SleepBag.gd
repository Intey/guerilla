extends Node2D


func _process(delta):
    pass

func _on_Area2D_body_entered(body):
    if body is Player:
        body.set_sleep_zone(true)


func _on_Area2D_body_exited(body):
    if body is Player:
        body.set_sleep_zone(false)
