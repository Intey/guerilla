extends Building
class_name Campfile


export onready var fear_radius = $AnimalFearArea/Shape.shape.radius
export var camp_distance: float 


func _on_CraftArea_body_entered(body):
    if body is Pawn:
        body.enter_campfire_zone()


func _on_CraftArea_body_exited(body):
    if body is Pawn:
        body.exit_campfire_zone()
