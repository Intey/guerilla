extends "res://states/state.gd"

func update(delta):
    .update(delta)
    var host = self.host
    var BB = host.BB
    var target = BB.get('player')
    var fp = BB.get('fear_point')
    if fp:
        if target and not host.too_close(fp):
            var player_near_fear = (fp.position - target.position).length() < fp.fear_radius
            if player_near_fear:
                return
            if (fp.position - host.position).dot(target.position - host.position) < 0:
                throttle_print("PURSUIT")
                return host.PURSUIT
        else:
            throttle_print("FLEEING")
            return host.FLEEING
    else:
        return host.PREVIOUS