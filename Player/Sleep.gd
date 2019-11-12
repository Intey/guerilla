extends "res://states/state.gd"

export var sleeping_inc := 0.1

func update_impl(delta):
   
    if Input.is_action_just_pressed("ui_interact"):
        return self.host.PREVIOUS
        
    self.sleep(sleeping_inc * delta)

func sleep(time):
    var host = self.host
    host.sleep_time += time
    if host.sleep_time > host.max_sleep_time:
        host.sleep_time = host.max_sleep_time
    