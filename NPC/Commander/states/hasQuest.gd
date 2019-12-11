extends "res://states/state.gd"

var animals := 0
var show_describe = false
var has_reward = false
onready var click_area = $"../../ClickArea"
onready var quest_sign = $"../../ClickArea/QuestAvailable"


func on_enter():            
    click_area.connect("input_event", self, "_on_ClickArea_input_event")
    self.quest_sign.visible = true

    
func on_exit():
    click_area.disconnect("input_event", self, "_on_ClickArea_input_event")
    self.quest_sign.visible = false
    self.show_describe = false
    self.has_reward = false
    
    
func update_impl(delta):
    if self.has_reward:
        return self.host.HAS_REWARD
    if show_describe:
        return self.host.SHOW_DETAILS
    if self.animals < 3:
        return self.host.IDLE
    
    
func physics_process_impl(delta):
    pass


func _on_ClickArea_input_event(viewport, event, shape_idx):
    if event.is_action_pressed("ui_select"):
        self.show_describe = true