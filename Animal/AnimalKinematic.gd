extends KinematicBody2D
class_name Animal
export var speed: float = 100.0
# var unit : Unit
export var random_roam: bool

func on_dead():
    print_debug("animal dead")
    queue_free()
    

# state for select
var PREVIOUS = FSM.PREVIOUS_STATE
var ROAMING = "roaming"
var PURSUIT = "pursuit" 
var FLEEING = "fleeing"
var WAIT = "wait" 

var velocity: Vector2

# BlackBoard. Used for collect knowledges with events, that came from detection area, collision shape, etc.
var BB := Dictionary()
    
var colors = {
    ROAMING: Color(0, 1, 0),
    PURSUIT: Color(1, 0, 0),
    FLEEING: Color(0, 0, 1),
    WAIT: Color(0.5, 0.5, 0.5),
}

var GT = null
onready var states_map = {
    ROAMING: $SM/Roaming.init(self),
    PURSUIT: $SM/Pursuiting.init(self),
    FLEEING: $SM/Fleeing.init(self),
    WAIT: $SM/Wait.init(self),
}

var roam_target = null

func set_roam_target(target):
    if states_map == null:
        roam_target = target
    else:
        var roam_state = states_map[ROAMING]
        roam_state.target_direction = target
        roam_state.random_roam = self.random_roam
# Transitions
# event | source | target
# enter fear area | 
func _ready():
    if roam_target:
        set_roam_target(roam_target)
    $SM.init(states_map, ROAMING)
    # self.unit = Unit.new(100, funcref(self, "on_dead"))
    self.GT = get_node('/root/World/GlobalTime')
    if self.GT == null:
        self.GT = load('res://World/GlobalTime.tscn').instance()
    
func move(delta, velocity):
    """
    Interface for state. All logic is in state.
    """
    # 
    move_and_slide(velocity * self.GT.timespeed)
    #if collision:
    #    print_debug('collide ', collision)
    #print_debug("go to ", last_farest_direction)

#TODO: deligates to current state
func _draw():
    $ColorRect.color = colors.get($SM.current_state, Color(1, 1, 1))
    draw_line(Vector2(), velocity * 20, Color(0,1,0))
    #if BB.get('player'):
    #    var target = BB['player']
    #    var pos = target.position - position
    #    draw_line(Vector2(), pos, Color(1,0,0))
 
func _physics_process(delta):
    update() # for redrawing
    

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
        
func hit(dmg: int):
    print_debug("animal hitted")
    $AnimationPlayer.play("hit")
    # self.unit.take_damage(dmg)
