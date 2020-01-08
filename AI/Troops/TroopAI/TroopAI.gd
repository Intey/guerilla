extends Node
class_name TroopAI

var troop: Troop
var follow = false

const FOLLOW = 'follow'

var position setget set_pos,get_pos

var states = {}

    
func init(troop):
    self.name = "TroopAI"
    print_debug("init TroopAI")
    self.troop = troop


func _ready():
    assert self.troop != null
    self.states = {
        FOLLOW: $FSM/FollowLeader.init(self)
    }
    print_debug("ready")
    $FSM.init(states, FOLLOW)
    
    
func detect_body(body):
    if body in self.troop.teammates:
        return
    elif body is Pawn:
        print_debug("TroopAI detect Pawn ", body.name)
        
func teach(pawn: Pawn):
    print_debug(" teach pawn ", pawn, " to trooping")
    pawn.add_child(self)
    var vv = pawn.find_node("ViewArea")
    if vv == null:
        print_debug("View Area not found in Pawn")
    else:
        vv.connect("body_entered", self, "detect_body")
    
func set_pos(pos):
    var pawn: Pawn = get_parent()
    pawn.position = pos


func get_pos():
    var pawn: Pawn = get_parent()
    return pawn.position
    

    