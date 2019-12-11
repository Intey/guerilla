extends "res://states/state.gd"

var timeout = false

func on_enter():
    $Timer.start()
    $Timer.connect("timeout", self, "ondone")
    self.timeout = false
    

func on_exit():
    $Timer.stop()
    $Timer.disconnect("timeout", self, "ondone") 

    
func update_impl(delta):
    if self.timeout:
        return self.host.IDLE


func ondone():
    self.timeout = true