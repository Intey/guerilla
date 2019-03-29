extends Panel

var ReciepeItem = preload('res://ReciepeItem.tscn')

signal craft(reciepe_name)
"""
init(inventory, reciepes)

"""

var selected_reciepe: ReciepeItem = null
var inventory = []
var reciepes = []

func can_build(reciepe, inventory):
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        if inventory.get(res_name, 0) < count:
            return false
    return true

func init(inventory, reciepes):
    self.reciepes = reciepes
    self.inventory = inventory
    for item_name in self.inventory:
        _add_ingridient(item_name, self.inventory[item_name])

    for reciepe_name in self.reciepes:
        var reciepeItem = ReciepeItem.instance()
        reciepeItem.set_item_name(reciepe_name)
        var buildable = can_build(self.reciepes[reciepe_name], self.inventory)
        reciepeItem.set_disabled(not buildable)
        $Reciepes.add_child(reciepeItem)
        reciepeItem.connect('selected', self, '_on_reciepe_selected')        
        
func _add_ingridient(name, count):
    $ItemList.add_item(name)
    $Counts.add_item(String(count))
    
func _on_reciepe_selected(reciepe: ReciepeItem):
    if selected_reciepe:
        selected_reciepe.set_selected(false)
    selected_reciepe = reciepe
    reciepe.set_selected(true)

func on_craft_button_pressed():
    if selected_reciepe:
        emit_signal('craft', selected_reciepe.get_item_name())
