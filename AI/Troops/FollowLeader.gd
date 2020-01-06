extends "res://states/state.gd"

export(int) var follow_distance = 10

func update_impl(delta):
    pass
    #print_debug("Not implemented state method 'update_impl' ", self.host.name, ".", self.name)
    
func physics_process_impl(delta):
    self.leader = host.troop.get_my_leader(self)
    var leader_pos = self.leader.position
    var targetpos: Vector2 = leader_pos - host.position
    self.follow = host.position.distance_to(leader_pos) > self.follow_distance
    if self.follow:
        host.velocity = targetpos.normalized()