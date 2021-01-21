extends Node2D
class_name Corpse

onready var inventory = $Inventory

func clone_resources(target): # SOme, that has Inventory
    # TODO: add resources from target
    self.inventory.clear()
    for i in target.inventory.items():
    
        self.inventory[i.name] = i.count
    

func set_loot(loot: Dictionary):
    self.inventory.clear()
    for k in loot:
        self.inventory.add(k, loot[k])
