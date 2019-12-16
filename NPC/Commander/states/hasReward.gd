extends "res://states/state.gd"

onready var click_area := $"../../ClickArea"
onready var quest_reward := $"../../ClickArea/QuestReward"


func on_enter():
    self.quest_reward.visible = true
    self.click_area.connect("input_event", self, "interact")
    
    
func on_exit():
    self.quest_reward.visible = false
    self.click_area.disconnect("input_event", self, "interact")
    

func update_impl(delta):
    if not self.host.has_reward():
        return self.host.IDLE
        
        
func interact(viewport, event, shape_idx):
    if event.is_action_pressed("ui_select"):
        #TODO: select rewarding quest
        self.host.reward()
        

func soft_transit(state):
    return false
