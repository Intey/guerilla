extends 'res://state.gd'

func update(delta):
    .update(delta)
    var host = self.host
    var target = host.BB.get('player')
    var fp = host.BB.get('fear_point')
    if fp:
        if target and (target.position - host.position).length() < (fp.position - host.position).length():
            if (host.position - fp.position).dot(target.position) < 0:
                return
            else:
                return host.WAIT
        else:
            return host.FLEEING
    if not target:
        return host.PREVIOUS
    
    pursuit(delta, target)
    
func pursuit(delta, target):
    var host = self.host
    var pos = target.position - host.position
    host.velocity = pos.normalized() * host.speed
    host.move(delta, host.velocity)