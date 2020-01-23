extends Pawn
class_name NPC

export var view_radius := 200

var visible_enemies = []
var nearest_enemy = null

const PURSUIT_STATE = "Pursuit"
const IDLE_STATE = "Idle"
const ATTACK_STATE = "Attack"


func _ready():
    # rebind params
    $ViewArea/View.shape.radius = view_radius
    $ViewArea.connect("body_entered", self, "detect_body")
    $ViewArea.connect("body_exited", self, "undetect_body")

    if self.fraction == Pawn.Fraction.Left:
        $ColorRect.color = Color(1, 0, 0)
    if self.fraction == Pawn.Fraction.Right:
        $ColorRect.color = Color(0, 0, 1)
    $FSM.init()

func detect_body(body):
    if not (body is Pawn and self.is_enemy(body)):
        return
    body.connect("dead", self, "undetect_body")
    self.visible_enemies.push_back(body)

func undetect_body(body):
    if not (body is Pawn and self.is_enemy(body)):
        return
    self.visible_enemies.erase(body)
    if body == nearest_enemy:
        nearest_enemy = null


func view_enemy():
    return len(self.visible_enemies) > 0
