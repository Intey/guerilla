extends 'BaseState.gd'
var utils = preload("res://Utility/utils.gd")

func update_impl(delta):
    
    var host = self.host
    var BB = host.BB
    var target = BB.get('player')
    var fp = BB.get('fear_point')
    if fp:
        if target and not host.too_close(fp):
            var player_near_fear = target_near_fear_area(target, fp)
            if player_near_fear:
                return
            if (fp.position - host.position).dot(target.position - host.position) < 0:
                utils.throttle_print(delta, "PURSUIT")
                return host.PURSUIT
        else:
            utils.throttle_print(delta, "FLEEING")
            return host.FLEEING
    else:
        return host.PREVIOUS
