extends FSMState

func update_impl(delta):
    var target = self.host.nearest_enemy
    if target == null or target.is_queued_for_deletion():
        return self.host.IDLE_STATE

    self.host.shoot(delta, target.global_position)
    var pos = self.host.global_position
    var shoot_range = self.host.shoot_range
    if pos.distance_to(target.global_position) > shoot_range:
        return self.host.PURSUIT_STATE
