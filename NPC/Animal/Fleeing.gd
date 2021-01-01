extends 'BaseState.gd'
var utils = preload("res://Utility/utils.gd")

func update_impl(delta):
    # TODO: fleeing some time before change state
    var host = self.host
    var fp = host.BB.get('fear_point')
    var target = host.BB.get('player')
    # if nothing to fear - get back to previous state
    if not host.too_close(fp):
        utils.throttle_print(delta, "STOP FLEE. ROAM")
        return host.ROAMING
    
    flee(delta, fp)
        
func flee(delta, fp):
    var host = self.host
    host.velocity = (host.position - fp.position).normalized() * host.speed
    host.move(delta, host.velocity)
    