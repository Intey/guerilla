extends Pawn
class_name NPC

export var view_radius := 200

func _ready():
    # rebind params
    $ViewArea/View.shape.radius = view_radius