extends Node

var inventory = {}

signal update(inventory)


func add(collected: ResourceItem):
    if collected.name in inventory:
        inventory[collected.name] += collected.count
    else:
        inventory[collected.name] = collected.count
    print_debug(
        'collected ', 
        collected.count, 
        ' ', 
        collected.name, 
        ". now player has ", 
        inventory
    )
    emit_signal('update', self.inventory)
    
    
func subtract(res: ResourceItem) -> bool:
    print_debug("try substract ", res.name, ":", res.count)
    if self.inventory.get(res.name, 0) < res.count:
        return false
        
    self.inventory[res.name] -= res.count
    if self.inventory[res.name] == 0:
        self.inventory.erase(res.name)
    emit_signal("update", self.inventory)
    return true
