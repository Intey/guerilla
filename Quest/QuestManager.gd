"""
Quest manager handle 
- moving quest from npc to player
- closing/opening quests
"""
extends Node

var active_quests = []


func assign_to_player(quest: Quest):
    print_debug("assign quest to player")
    self.active_quests.append(quest)
    
    
func reward(quest: Quest):
    print_debug("reward player")
    assert(quest in self.active_quests)