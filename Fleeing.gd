extends 'res://state.gd'

func update(delta):
    .update(delta)
    var host = self.host
    var fp = host.BB.get('fear_point')
    var target = host.BB.get('player')
    # if nothing to fear - get back to previous state
    if not fp:
        return host.PREVIOUS
        
    # if player closer than fear_point and we are in fear_point area - wait for player
    # else - fleeing    
    if host.too_close(fp):
        return
    
    flee(delta, fp)
        
func flee(delta, fp):
    var host = self.host
    host.velocity = (host.position - fp.position).normalized() * host.speed
    host.move(delta, host.velocity)
    