extends "res://states/state.gd"

onready var description_view = $"../../QuestDescription"
onready var click_area = $"../../ClickArea"

var has_reward := false
var assigned := false


func on_enter():
    description_view.visible = true
    var quest = self.host.available_quests[0]    
    description_view.text = quest.quest_description
    click_area.connect("input_event", self, "_on_ClickArea_input_event")

    
func on_exit():
    description_view.visible = false
    click_area.disconnect("input_event", self, "_on_ClickArea_input_event")
    self.has_reward = false
    self.has_quest = true
    self.assigned = false
    

func update_impl(delta):
    # when we show quest, and it's gone away, we needs to show this
    if not self.host.available_quests:
        return self.host.QUEST_OUT

    var quest = self.host.available_quests[0]    
    if self.has_reward:
        return self.host.HAS_REWARD
    if self.assigned:
        return self.host.IDLE


func _on_ClickArea_input_event(viewport, event, shape_idx):
    var quest = self.host.available_quests[0]    
    questManager.assign_to_player(quest)


func soft_trainsit(state):
    return false
