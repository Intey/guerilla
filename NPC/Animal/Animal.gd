extends Pawn
class_name Animal

var velocity: Vector2

# BlackBoard. Used for collect knowledges with events, that came from detection area, collision shape, etc.
var BB := Dictionary()
    
var colors = {
    ROAMING: Color(0, 1, 0),
    PURSUIT: Color(1, 0, 0),
    FLEEING: Color(0, 0, 1),
    WAIT: Color(0.5, 0.5, 0.5),
}

var roam_target = null


# state for select
var PREVIOUS = FSM.PREVIOUS_STATE
var ROAMING = "roaming"
var PURSUIT = "pursuit" 
var FLEEING = "fleeing"
var WAIT = "wait" 

onready var states_map = {
    ROAMING: $FSM/Roaming.init(self),
    PURSUIT: $FSM/Pursuiting.init(self),
    FLEEING: $FSM/Fleeing.init(self),
    WAIT: $FSM/Wait.init(self),
}


func _ready():
    if roam_target:
        set_roam_target(roam_target)
    $FSM.init(states_map, ROAMING)
    # self.unit = Unit.new(100, funcref(self, "on_dead"))
    
    
func move(delta, velocity):
    move_and_slide(velocity)


#TODO: deligates to current state
func _draw():
    $ColorRect.color = colors.get($FSM.current_state, Color(1, 1, 1))
    draw_line(Vector2(), velocity * 20, Color(0,1,0))


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
        

func take_damage(dmg: int):
    .take_damage(dmg)
    $AnimationPlayer.play("hit")
    # self.unit.take_damage(dmg)
        

# FOR Events
func set_roam_target(target):
    if states_map == null:
        roam_target = target
    else:
        var roam_state = states_map[ROAMING]
        roam_state.target_direction = target
        roam_state.random_roam = self.random_roam

