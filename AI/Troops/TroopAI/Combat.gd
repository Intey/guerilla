extends "res://states/state.gd"

func update_impl(delta):
    if not self.host.is_view_enemy():
        return FSM.PREVIOUS_STATE
    self.host.position.distance_to(self.host.nearest_enemy)
    self.host.pawn.shoot(delta, self.host.nearest_enemy.position)
    