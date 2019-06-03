extends 'res://Animal/BaseState.gd'

func update(delta):
    .update(delta)
    var host = self.host
    var fp = host.BB.get('fear_point')
    var target = host.BB.get('player')
    # if nothing to fear - get back to previous state
    if not host.too_close(fp):
        throttle_print("STOP FLEE. ROAM")
        return host.ROAMING
    flee(delta, fp)
        
func flee(delta, fp):
    var host = self.host
    host.velocity = (host.position - fp.position).normalized() * host.speed
    host.move(delta, host.velocity)
    