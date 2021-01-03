extends Node
# Troop structure
class_name Troop

var teammates := []
var leader: Pawn
var distance := 15

enum Formation {
        Arrow = 1,
        Line,
}


func _init(lead, teammates_, distance_=45):
    if len(teammates_) == 0:
        return
    for i in range(1, len(teammates_)):
        self.teammates.push_back(teammates_[i])
        
    self.leader = lead
    self.distance = distance_


func get_my_leader(_pawn: Pawn) -> Pawn:
    return self.leader


func formation() -> int:
    return Formation.Line
