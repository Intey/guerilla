extends Pawn
class_name NPC

export var view_radius := 200

func _ready():
    # rebind params
    $ViewArea/View.shape.radius = view_radius
    if self.fraction == Pawn.Fraction.Left:
        $ColorRect.color = Color(1, 0, 0)
    if self.fraction == Pawn.Fraction.Right:
        $ColorRect.color = Color(0, 0, 1)
    if self.name == "Pawn2":
        $ColorRect.color = Color(1, 1, 0)
