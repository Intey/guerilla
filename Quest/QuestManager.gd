"""
Quest manager handle 
- moving quest from npc to player
- closing/opening quests
"""
extends Node

#onready var player := $"/root/World/Player"
var active_quests = []
var quest_owners = []


func _ready():
    #var commander := $"/root/World/Commander"
    #self.quest_owners.append(commander)    
    pass
       
    
func assign_to_player(quest: Quest):
    self.active_quests.append(quest)
    self.__direct_control(quest)


func __direct_control(quest: Quest):
    if quest.type == 'kill':
        self.player.connect("kills", quest, "on_player_kills")
    
    
func reward(quest: Quest):
    assert(quest in self.active_quests)
    #self.player.add_resources()
    ## anyone can done quest
    #quest.owner.done_quest(quest, self.player)