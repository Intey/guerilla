"""
Quest manager handle 
- moving quest from npc to player
- closing/opening quests
"""
extends Node

var active_quests = []
var available_quests = []

var _idle_quests = 'idle'
var _available_quests = 'available'
var _reward_quests = 'reward'
var _assigned_quests = 'assigned'
var _completed_quests = 'completed'
var quests := {} # look at __init_quests_struct

func _init():
    self.quests = __init_quests_struct()
    
signal quest_available(quest, available)


func add_quest(quest: Quest):
    for k in [_idle_quests, _available_quests, _reward_quests, 
              _assigned_quests, _completed_quests]:
        if quest in self.quests[k]:
            return
    
    self.quests[_idle_quests].append(quest)
    self.add_child(quest)
    var error = quest.connect("available", self, "on_quest_available")
    assert error == 0
    
    
func assign_quest(quest: Quest, assignee):
    #TODO: assignee to any pawn
    print_debug("assign quest to ", assignee)
    quest.assign_to(assignee)
    
    self.quests[_available_quests].erase(quest)
    self.quests[_assigned_quests].append(quest)
    
    quest.connect("completed", self, "on_quest_completed")
    
    
func reward(quest: Quest):
    assert quest in self.quests[_reward_quests]
    print_debug("reward ", quest)
    self.quests[_reward_quests].erase(quest)
    self.quests[_completed_quests].append(quest)
        
    
func on_quest_available(quest: Quest, available: bool):
    # not emit signal, if quest availability not changed
    print_debug("new quest available?")
    var owner_quests = self.quests
    if available and owner_quests[_available_quests].has(quest):
        return
    print_debug("new quest available")
    if available:
        owner_quests[_available_quests].append(quest)
    else:
        owner_quests[_available_quests].erase(quest)
        
    emit_signal("quest_available", quest, available)
    
    
func on_quest_completed(quest: Quest):
    var assigned_quests = self.quests[_assigned_quests]
    assert quest in assigned_quests
    assigned_quests.erase(quest)
    self.quests[_reward_quests].append(quest)
    
    
func get_reward_quests(owner):
    return self._filter_owner_quests(owner, self.quests[_reward_quests])
    
func get_available_quests(owner):
    return self._filter_owner_quests(owner, self.quests[_available_quests])
    
func _filter_owner_quests(owner, quests):
    var result = []
    for q in quests:
        if q.quest_owner == owner:
            result.append(q)
    return result
    
func __init_quests_struct():
    return {
        _idle_quests: [],
        _available_quests: [],
        _reward_quests: [],
        _assigned_quests: [],
        _completed_quests: []
    }
    
    