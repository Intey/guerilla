extends Node
class_name TroopAI

var troop: Troop
var pawn: Pawn

const FOLLOW = 'follow'
const COMBAT = 'combat'

# change/get position of pawn
var position setget set_pos,get_pos

var states = {}

var nearest_enemy = null
    
func init(troop):
    self.name = "TroopAI"
    self.troop = troop


func _ready():
    assert self.troop != null
    self.states = {
        FOLLOW: $FSM/FollowLeader.init(self),
        COMBAT: $FSM/Combat.init(self)
    }
    
    
func detect_body(body):
    if body in self.troop.teammates:
        return
    elif body is Pawn:
        if body.fraction != self.pawn.fraction:
            if self.nearest_enemy == null:
                self.nearest_enemy = body 
            elif (
                self.pawn.position.distance_to(body.position) 
                    < self.pawn.position.distance_to(self.nearest_enemy.position)
                ):
                nearest_enemy = body
            
            print_debug("TroopAI detect enemy Pawn ", body.name)
            
        
func is_view_enemy():
    return nearest_enemy != null
    
    
func teach(pawn: Pawn):
    if pawn in Player:
        print_debug("dont teach AI to player")
        return
    print_debug(" teach pawn ", pawn, " to trooping")
    pawn.add_child(self)
    self.pawn = pawn
    var vv = pawn.find_node("ViewArea")
    if vv == null:
        print_debug("View Area not found in Pawn")
    else:
        vv.connect("body_entered", self, "detect_body")
        
    $FSM.init(states, FOLLOW)
    
    
func set_pos(pos):
    self.pawn.position = pos


func get_pos():
    return self.pawn.position
    

func shoot(target: Vector2):
    #TODO: pass delta
    self.pawn.shoot(0, target)
