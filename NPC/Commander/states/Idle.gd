extends "res://states/state.gd"


func update_impl(delta):
    if not self.host.available_quests.empty():
        return self.host.HAS_QUEST