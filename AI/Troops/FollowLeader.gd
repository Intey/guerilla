extends "res://states/state.gd"

export(int) var follow_distance = 10


func physics_process_impl(delta):
    var leader = host.troop.get_my_leader(self)
    var leader_pos = leader.position
    var velocity: Vector2 = (leader_pos - host.position).normalized()
    var follow = host.position.distance_to(leader_pos) > self.follow_distance
    if follow:
        var pawn = host.get_parent()
        pawn.move_and_slide(velocity * pawn.speed)# TODO: multiply on GT.timespeed
        # pawn.velocity = targetpos.normalized()
