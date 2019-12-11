extends "res://states/state.gd"


func update_impl(delta):
    if self.debug:
        pass
        
    if self.host.available_quests:
        return self.host.HAS_QUEST