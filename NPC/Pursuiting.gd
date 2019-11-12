extends "res://states/state.gd"
func update_impl(delta):
    var host: Node2D = self.host
    var player = host.BB.get('player')
    if not player:
        return host.ROAMING
    if host.position.distance_to(player.position) <= host.shoot_range:
        return host.ATTACK
    var dir = player.position - host.position
    host.move(delta, dir)