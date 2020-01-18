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


func _init(teammates, distance=45):
    if len(teammates) == 0:
        return
    for i in range(1, len(teammates)):
        self.teammates.push_back(teammates[i])
        
    self.leader = teammates[0]
    self.distance = distance


func get_my_leader(pawn: Pawn) -> Pawn:
    return self.leader


func formation() -> int:
    return Formation.Line
