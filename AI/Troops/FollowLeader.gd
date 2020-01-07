extends "res://states/state.gd"

export(int) var follow_distance = 10


func physics_process_impl(delta):
    var leader = host.troop.get_my_leader(self)
    var pawn = host.get_parent()
    
    var leader_pos = leader.global_position
    
    var velocity: Vector2 = (leader_pos - pawn.global_position).normalized()
    
    print_debug(leader_pos, self.follow_distance, pawn.global_position)
    
    var follow = pawn.global_position.distance_to(leader_pos) > self.follow_distance
    if follow:
        pawn.move_and_slide(velocity * pawn.speed)# TODO: multiply on GT.timespeed
        print_debug("follow leader")
