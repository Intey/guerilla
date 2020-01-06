extends Pawn
class_name NPC

export var view_radius := 200

func _ready():
	# rebind params
	$ViewArea/View.radius = view_radius