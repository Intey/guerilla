extends Node
class_name ConditionalEvent

var appears = false

var GT: GlobalTime

# source of information, from which we get condition. We can use it, or nodes
# nodes is preffered for static nodes(that can't be removed in game) 
var DataSource: Blackboard
var player: Player
# specific for concrete event. Should be in DSL with predicate (and event itself?)
export var position = Vector2(0, 0)
export var nea_distance = 10

func _ready():
    GT = get_node('/root/World/GlobalTime')
    player = get_node("/root/World/Player")
    assert(GT != null)


func _process(delta):
    delta = GT.timespeed * delta
    self.process(delta)


func process(delta):
    pass
    
func appears():
    appears = true
    
func event():
    # spawn animals, run video, create quests
    print_debug("CONDITION READY")
    
func predicate():
    # if we need something like "player near point"
    if player == null:
        return false
    # assert(player != null && "without player this predicate should not be called")
    return position.distance_to(player.global_position) <= self.near_distance
    # or for conditions, that calculates in blackboard in-time, 
    # or expects many items to participate in condition   
    #return bool(DataSource.get('event.condition'))