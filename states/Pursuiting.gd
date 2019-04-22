extends 'res://states/state.gd'

func update(delta):
    .update(delta)
    var host = self.host
    var target = host.BB.get('player')
    var fp = host.BB.get('fear_point')
    if fp and host.too_close(fp):
        if target_near_fear_area(target, fp):
            return host.WAIT
        throttle_print("STOP PURSUIT. FLEE")
        return host.FLEEING
    
    if not target:
        return host.ROAMING
    
    pursuit(delta, target)
    
func pursuit(delta, target):
    var host = self.host
    var pos = target.position - host.position
    host.velocity = pos.normalized() * host.speed
    host.move(delta, host.velocity)