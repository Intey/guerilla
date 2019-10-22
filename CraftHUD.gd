extends Panel

var ReciepeItem = preload('res://ReciepeItem.tscn')
var CraftStation = preload('res://CraftStation.gd')

signal craft(reciepe_name)

var selected_reciepe: ReciepeItem = null
var reciepes = []


func init(inventory, reciepes):
    self.reciepes = reciepes
    self.render_ingridients(inventory)
    for reciepe_name in self.reciepes:
        var reciepeItem = ReciepeItem.instance()
        reciepeItem.set_item_name(reciepe_name)
        var rec_icon = load(self.reciepes[reciepe_name].icon)
        if rec_icon:
            reciepeItem.set_item_img(rec_icon)
        var buildable = CraftStation.can_build(self.reciepes[reciepe_name], inventory)
        reciepeItem.set_disabled(not buildable)
        $Reciepes.add_child(reciepeItem)
        reciepeItem.connect('selected', self, '_on_reciepe_selected')        
        
        
func update_state(new_inventory):
    $Items/ItemList.clear()
    $Items/Counts.clear()
    render_ingridients(new_inventory)
    
    for ch in $Reciepes.get_children():
        var buildable = CraftStation.can_build(self.reciepes[ch.get_item_name()], new_inventory)
        ch.set_disabled(not buildable)
    
    
func render_ingridients(inventory):     
    if not inventory.empty():
        for item_name in inventory:
            _add_ingridient(item_name, inventory[item_name])  
            
            
func _add_ingridient(name, count):
    $Items/ItemList.add_item(name)
    $Items/Counts.add_item(String(count))
    
    
func _on_reciepe_selected(reciepe: ReciepeItem):
    print_debug("select recipe:", reciepe)
    if selected_reciepe:
        selected_reciepe.set_selected(false)
    selected_reciepe = reciepe
    reciepe.set_selected(true)


func _on_craft_pressed():
    if selected_reciepe:
        emit_signal('craft', selected_reciepe.get_item_name())
