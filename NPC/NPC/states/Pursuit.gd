extends "res://states/state.gd"


var vel: Vector2 = Vector2()
var last_seen_in = null

func update_impl(delta):
    var nearest_enemy = self.host.nearest_enemy
    var target_pos = null

    if nearest_enemy == null:
        if last_seen_in == null:
            return self.host.IDLE_STATE
        else:
            target_pos = last_seen_in
    else:
        target_pos = nearest_enemy.global_position

    var host_pos = self.host.global_position
    vel = Velik.relvel(host_pos, target_pos)
    vel = vel * self.host.speed

    # we came to last seen position
    if target_pos == last_seen_in and host_pos.distance_to(target_pos) < 1:
        last_seen_in = null
    else:
        last_seen_in = target_pos
    if host_pos.distance_to(target_pos) < self.host.shoot_range:
        return self.host.ATTACK_STATE


func physics_process_impl(delta):
    self.host.move_and_slide(vel)

