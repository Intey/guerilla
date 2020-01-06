extends Node
# Troop structure
class_name Troop

var teammates := []
var leader: Pawn


func _init(teammates):
    self.teammates = teammates
    self.leader = teammates[0]
    

func get_my_leader(pawn: Pawn):
    return self.leader