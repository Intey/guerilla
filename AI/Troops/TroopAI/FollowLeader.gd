extends "res://states/state.gd"

export(int) var follow_distance = 10


func update_impl(_delta):
    if self.host.is_view_enemy():
        return self.host.COMBAT

    
func physics_process_impl(_delta):
    var target_pos = self.host.pawn.target_pos
    if self.host.pawn.global_position.distance_to(target_pos) < follow_distance:
        return
    var vel = (target_pos - self.host.pawn.global_position).normalized()
    self.host.pawn.move_and_slide(vel * self.host.pawn.speed )
