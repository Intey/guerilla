extends "res://states/state.gd"


func update(delta):
    .update(delta)
    var host = self.host
    var player = host.BB.get('player')
    if host.position.distance_to(player.position) > host.shoot_range:
        return host.PURSUIT
    host.fire(delta)
