extends KinematicBody2D
class_name Animal
export var speed: float = 100.0
# state for select
enum { 
    ROAMING = 1, 
    PURSUIT, 
    FLEEING,
    WAIT, 
    PREVIOUS 
}

var health = 100 setget set_health
var velocity: Vector2

# BlackBoard. Used for collect knowledges with events, that came from detection area, collision shape, etc.
var BB := Dictionary()
    
var colors = {
    ROAMING: Color(0, 1, 0),
    PURSUIT: Color(1, 0, 0),
    FLEEING: Color(0, 0, 1),
    WAIT: Color(0.5, 0.5, 0.5),
}

var current_state = null
var states_stack = []
onready var states_map = {
    ROAMING: $SM/Roaming.init(self),
    PURSUIT: $SM/Pursuiting.init(self),
    FLEEING: $SM/Fleeing.init(self),
    WAIT: $SM/Wait.init(self),
}
# Transitions
# event | source | target
# enter fear area | 

func _ready():
    states_stack.push_front(ROAMING)
    current_state = states_stack[0]
    _change_state(ROAMING)
    
func _change_state(state):
    if state == PREVIOUS:
        states_stack.pop_front()
    else:
        states_stack.push_front(state)
    current_state = states_stack[0]
    

func move(delta, velocity):
    var collision = move_and_collide(velocity * delta)
    #if collision:
    #    print_debug('collide ', collision)
    #print_debug("go to ", last_farest_direction)

#TODO: deligates to current state
func _draw():
    $ColorRect.color = colors.get(current_state, Color(1, 1, 1))
    draw_line(Vector2(), velocity * 20, Color(0,1,0))
    if BB.get('player'):
        var target = BB['player']
        var pos = target.position - position
        draw_line(Vector2(), pos, Color(1,0,0))
     
func _physics_process(delta):
    update() # for redrawing
    var new_state = states_map[current_state].update(delta)
    if new_state:
        _change_state(new_state)
    
func _on_DetectionArea_body_entered(body):
    if body.name == 'Player':
       BB['player'] = body
   
func _on_DetectionArea_body_exited(body):
    pass

func _on_DetectionArea_area_entered(area):
    if area.name == "AnimalFearArea":
        BB['fear_point'] = area.get_parent()
            

func _on_DetectionArea_area_exited(area):
    if area.name == "AnimalFearArea":
        pass
        
func too_close(fp):
    return (fp.position - position).length() < (fp.fear_radius)


func _on_PursuitArea_body_exited(body):
    if body.name == 'Player':
        BB.erase('player')
        
func set_health(value):
    health = value
    if health == 0:
        queue_free()

func hit():
    self.health -= 20
