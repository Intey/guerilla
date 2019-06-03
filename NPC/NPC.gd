extends KinematicBody2D

export var detection_radius: int
export var speed: float

# FIXME: not react on change from GUI. Making copy on state.init(self)?
export var shoot_range: int = 250 

# State machinary
enum {
    ROAMING = 1,
    PURSUIT,
    ATTACK,
    FLEEING,
    PREVIOUS
    }

# BlackBoard    
var BB = {}

# Debug colors for state visibility
var colors = {
    ROAMING: Color(0, 1, 0),
    PURSUIT: Color(1, 0, 0),
    FLEEING: Color(0, 0, 1),
    ATTACK: Color(1, 1, 0),
}


# ============ State machinary
var current_state = null
var states_stack = []
onready var states_map = {
    ROAMING: $SM/Roaming.init(self),
    PURSUIT: $SM/Pursuiting.init(self),
    ATTACK: $SM/Attack.init(self),
}


func _change_state(state):
    if state == PREVIOUS:
        states_stack.pop_front()
    else:
        states_stack.push_front(state)
    current_state = states_stack[0]
# ============ END State machinary    
    
    
func _ready():
    $DetectionArea/Area.shape.radius = detection_radius
    _change_state(ROAMING) # init state
    $RangeWeapon.init(self)
    
    
func move(delta, direction: Vector2):
    """
    Move self to direction with self.speed
    Interface for state. All logic is in state.
    """
    var collision = move_and_collide(direction.normalized() * speed * delta)

     
func _physics_process(delta):
    update() # for redrawing
    var new_state = states_map[current_state].update(delta)
    if new_state:
        _change_state(new_state)
    
    
func _draw():
    $ColorRect.color = colors.get(current_state, Color(1, 1, 1))


func _on_DetectionArea_body_entered(body):
    if body.name == 'Player':
        BB['player'] = body


func _on_DetectionArea_body_exited(body):
    if body.name == 'Player':
        BB.erase('player')
        
func fire(delta):
    var player: Node2D = BB.get('player')
    var target = accuracy_fix(player.global_position)
    $RangeWeapon.fire(delta, target)
    
func accuracy_fix(vector: Vector2) -> Vector2:
    vector.x += rand_range(-0.2, 0.2)
    vector.y += rand_range(-0.2, 0.2)
    return vector.normalized()
    