extends "res://states/state.gd"
var utils = preload("res://Utility/utils.gd").new()

export var redirect_timeout := 1.0
var covered_map = null

var last_time_direction = INF # INF - start as ready
var target_point: Vector2

func select_new_direction():
    # get -1 or 1
    var one = [0, 2][(randi() % 2)] - 1
    if self.last_time_direction == 0:
        target_point = Vector2(randf() * one, randf() * one)
    return target_point
        
func update_impl(delta):
    host = self.host
    var player = host.BB.get('player')
    if player:
        return host.PURSUIT
    self.last_time_direction += delta    
    if self.last_time_direction >= self.redirect_timeout:
        self.last_time_direction = 0
    
func physics_process_impl(delta):
    var rand_dir = select_new_direction()
    host.move(delta, rand_dir)