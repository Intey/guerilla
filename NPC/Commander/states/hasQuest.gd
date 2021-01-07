extends "res://states/state.gd"

onready var click_area = $"../../ClickArea"
onready var quest_sign = $"../../ClickArea/QuestAvailable"


func on_enter():            
    assert(click_area.connect("input_event", self, "_on_ClickArea_input_event") == OK)
    self.quest_sign.visible = true

    
func on_exit():
    click_area.disconnect("input_event", self, "_on_ClickArea_input_event")
    self.quest_sign.visible = false
    
    
func update_impl(delta):
    if not self.host.has_quest():
        return self.host.IDLE 
    if self.host.current_quest:
        return self.host.SHOW_DETAILS
    
    
func _on_ClickArea_input_event(viewport, event: InputEvent, shape_idx):
    if event.is_action_pressed("ui_select") and Input.is_action_just_pressed("ui_select"):
        # TODO: select current quest
        self.host.display_quest()
