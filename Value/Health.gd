extends Value

class_name Health

var alive = true


func _init():
    ._init()
    
    
func hit(dmg):
    self.value -= dmg
    if self.value == 0:
        alive = false