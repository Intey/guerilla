extends Node
class_name GlobalTime

export var time := 0.0
export var timespeed := 1.0
var last_second = 0

# TODO: initiale on specific time(load game case)
func _process(delta):
    # TODO: use player timelaps stamina
    if Input.is_action_just_pressed("ui_timelapse"):
        timespeed = 0.4
    if Input.is_action_just_released("ui_timelapse"):
        timespeed = 1.0
        
    var scaled_delta = delta * timespeed
    time += scaled_delta
    last_second += scaled_delta
    if last_second >= 1:
        print_debug("time(", self, ") is: ", time)
        last_second = 0
        
        
    