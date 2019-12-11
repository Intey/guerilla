extends "res://states/state.gd"

var animals := 0

var has_quest := false
var has_reward := false

func on_enter():
    for q in self.host.quests:
        q.connect("available", self, "on_quest_available", [q])
        
func on_exit():
    for q in self.host.quests:
        q.disconnect("available", self, "on_quest_available")
    
    
func update_impl(delta):
    if self.has_quest:
        return self.host.HAS_QUEST
    if self.has_reward:
        return self.host.HAS_REWARD
        

func on_quest_available(quest:Quest, available):
    self.has_quest = available
    #TODO: how to pass quest object to next states? use state of commander?