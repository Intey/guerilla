extends "res://states/state.gd"

onready var description_view = $"../../QuestDescription"
onready var click_area = $"../../ClickArea"

var quest: Quest

var animals := 0
# we can't come there, if no quest available. 
# But we need to track that quest still needs to be done
var has_quest := true
var has_reward := false
var assigned := false

func _ready():
    self.quest = self.host.quest    
    self.animals = $"../Idle".animals


func on_enter():
    description_view.visible = true
    description_view.text = self.quest.quest_description
    click_area.connect("input_event", self, "_on_ClickArea_input_event")

    
func on_exit():
    description_view.visible = false
    click_area.disconnect("input_event", self, "_on_ClickArea_input_event")
    self.has_reward = false
    self.has_quest = true
    self.assigned = false
    
func update_impl(delta):
    if self.has_reward:
        return self.host.HAS_REWARD
    if self.assigned:
        return self.host.IDLE
    if not self.has_quest:
        return self.host.IDLE

func _on_ClickArea_input_event(viewport, event, shape_idx):
    questManager.assign_to_player(quest)

func _on_View_body_exited(body):
    self.animals -= 1
    if self.animals < 3:
        self.has_quest = false


func soft_trainsit(state):
    return false
