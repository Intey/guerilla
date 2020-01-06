extends Node
class_name TroopAI

var troop: Troop
var follow = false
var leader: Pawn

var FOLLOW ='follow'

var position setget set_pos,get_pos

var states = {
    FOLLOW: $FSM/FollowLeader.init(self)
}
    
    
func _ready():
    $FSM.init(states, FOLLOW)


func set_troop(troop):
    self.troop = troop

    
func detect_body(body):
    if body in self.troop.teammates:
        return
    elif body is Pawn:
        print_debug("TroopAI detect Pawn ", body.name)
        
    
func set_pos(pos):
    var pawn: Pawn = get_parent()
    pawn.position = pos


func get_pos():
    var pawn: Pawn = get_parent()
    return pawn.position
    