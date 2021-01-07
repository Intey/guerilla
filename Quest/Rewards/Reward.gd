extends Node
class_name Reward

var experience: int


func _init(xp: int):
    self.experience = xp
    
func _to_string():
    return "reward:" + str(self.experience)
