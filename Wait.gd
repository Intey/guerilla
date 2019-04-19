extends "res://state.gd"


func update(delta):
    .update(delta)
    var host = self.host
    var BB = host.BB
    var target = BB.get('player')
    var fp = BB.get('fear_point')
    
    # to close to fear point
    if host.too_close(fp):
        return host.FLEEING
    
    if target and fp:
        var player_near_fear = (target.position - fp.position).length() < fp.fear_radius
        var player_away_fp = (host.position - fp.position).dot(target.position) < 0            
        if player_near_fear:
            return 
        elif player_away_fp:
            return host.PURSUIT
