extends 'res://Animal/BaseState.gd'
var utils = preload("res://Utility/utils.gd")

func update_impl(delta):
    
    var host = self.host
    var target = host.BB.get('player')
    var fp = host.BB.get('fear_point')
    if fp and host.too_close(fp):
        if target_near_fear_area(target, fp):
            return host.WAIT
        utils.throttle_print(delta, "STOP PURSUIT. FLEE")
        return host.FLEEING
    
    if not target:
        return host.ROAMING

func physics_process_impl(delta):
    var target = host.BB.get('player')
    if target:
        self.pursuit(delta, target)
    
    
func pursuit(delta, target):
    var host = self.host
    var pos = target.global_position - host.global_position
    host.velocity = pos.normalized() * host.speed
    host.move(delta, host.velocity)