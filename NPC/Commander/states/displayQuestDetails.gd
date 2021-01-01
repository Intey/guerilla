extends "res://states/state.gd"

onready var description_view = $"../../ClickArea/QuestDescription"
onready var click_area = $"../../ClickArea"


func on_enter():
    description_view.visible = true
    var quest = self.host.current_quest
    description_view.text = quest.quest_description
    assert(click_area.connect("input_event", self, "_on_ClickArea_input_event") == 0)

    
func on_exit():
    self.description_view.visible = false
    click_area.disconnect("input_event", self, "_on_ClickArea_input_event")


func update_impl(delta):
    if not self.host.current_quest:
        return self.host.IDLE
        
    # when we show quest, and it's gone away, we needs to show this
    if not self.host.has_quest():
        return self.host.QUEST_OUT
        
    if self.host.has_reward():
        return self.host.HAS_REWARD


func _on_ClickArea_input_event(viewport, event, shape_idx):
    if event.is_action_pressed("ui_select") and Input.is_action_just_pressed("ui_select"):
        self.host.assign_current_quest()

        
func soft_trainsit(state):
    return false
