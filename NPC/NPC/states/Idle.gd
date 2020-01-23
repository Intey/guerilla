extends "res://states/state.gd"


func update_impl(delta):
    if self.host.view_enemy():
        self.host.nearest_enemy = self.host.visible_enemies[0]
        var min_pos = self.host.global_position.distance_to(self.host.nearest_enemy.global_position)
        for enemy in self.host.visible_enemies:
            var nd = self.host.global_position.distance_to(enemy.global_position)
            if nd < min_pos:
                min_pos = nd
                self.host.nearest_enemy = enemy
        return self.host.PURSUIT_STATE
