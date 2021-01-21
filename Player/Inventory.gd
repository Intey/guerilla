extends Node
class_name Inventory

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
        ". now ",
        get_parent().name, 
        " has ", 
        inventory
    )
    emit_signal('update', self.inventory)
    
    
func add_item(type: String, count: int):
    var item = ResourceItem.new(type, count)
    self.add(item)
    
func sub_item(type: String, count: int) -> bool:
    var item = ResourceItem.new(type, count)
    return self.subtract(item)
    
func subtract(res: ResourceItem) -> bool:
    print_debug("try substract ", res.name, ":", res.count)
    if self.inventory.get(res.name, 0) < res.count:
        return false
        
    self.inventory[res.name] -= res.count
    if self.inventory[res.name] == 0:
        self.inventory.erase(res.name)
    emit_signal("update", self.inventory)
    return true

func items():
    var items = []
    for k in inventory:
        var i = ResourceItem.new(k, inventory[k])
        items.append(i)
    return items        

func clear():
    inventory = {}
    emit_signal("update", self.inventory)

func get_count(item: String):
    return inventory[item]
