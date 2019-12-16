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
var quests := {
    _idle_quests: [],
    _available_quests: [],
    _reward_quests: [],
    _assigned_quests: [],
    _completed_quests: []
}

signal quest_available(quest, available)


func add_quest(owner, quest: Quest):
    if not self.quests.has(owner):
        self.quests[owner] = self.__init_quests_struct()
    self.quests[owner][_idle_quests].append(quest)
    self.add_child(quest)
    var error = quest.connect("available", self, "on_quest_available", [owner])
    assert error == 0
    
    
func assign_to_player(owner, quest: Quest):
    print_debug("assign quest to player")
    self.quests[owner][_available_quests].erase(quest)
    self.quests[owner][_assigned_quests].append(quest)
    
    quest.connect("completed", self, "on_quest_completed", [owner])
    
    
func reward(owner, quest: Quest):
    print_debug("reward player")
    self.quests[owner][_reward_quests].erase(quest)
    self.quests[owner][_completed_quests].append(quest)
        
    
func on_quest_available(quest: Quest, available: bool, owner):
    # not emit signal, if quest availability not changed
    print_debug("new quest available?")
    var owner_quests = self.quests[owner]
    if available and owner_quests[_available_quests].has(quest):
        return
    print_debug("new quest available")
    if available:
        owner_quests[_available_quests].append(quest)
    else:
        owner_quests[_available_quests].erase(quest)
        
    emit_signal("quest_available", quest, available)
    
func on_quest_completed(quest: Quest, owner):
    self.quests[owner][_assigned_quests].erase(quest)
    self.quests[owner][_reward_quests].append(quest)
    
func get_reward_quests(owner):
    if self.quests.has(owner):
        return self.quests[owner][_reward_quests]
    return []
    
    
func get_available_quests(owner):
    if self.quests.has(owner):
        return self.quests[owner][_available_quests]
    return []
    
    
func __init_quests_struct():
    return {
        _idle_quests: [],
        _available_quests: [],
        _reward_quests: [],
        _assigned_quests: [],
        _completed_quests: []
    }
    
    