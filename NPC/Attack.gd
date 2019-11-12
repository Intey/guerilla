extends "res://states/state.gd"


func update_impl(delta):
    var host = self.host
    var player = host.BB.get('player')
    if player == null:
        return
    if host.position.distance_to(player.position) > host.shoot_range:
        return host.PURSUIT
    host.fire(delta)

func physics_process_impl(delta):
    pass