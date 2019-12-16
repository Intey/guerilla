extends "res://states/state.gd"
    
    
func update_impl(delta):
    if self.host.has_quest():
        return self.host.HAS_QUEST
    if self.host.has_reward():
        return self.host.HAS_REWARD