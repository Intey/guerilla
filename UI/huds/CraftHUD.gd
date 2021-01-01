extends Panel

var ReciepeItem = preload('res://Player/craft/ReciepeItem.tscn')
var crafts = preload('res://Player/craft/crafts.gd')

signal craft(reciepe_name)

var selected_reciepe: ReciepeItem = null
var reciepes = []
var player

func init(_player):
    self.player = _player        
    self.reciepes = crafts.get_crafts()
    self.render_ingridients(self.player._get_inventory())        
    self.init_reciepes()

func init_reciepes():
    for reciepe_name in self.reciepes:
        var reciepeItem = ReciepeItem.instance()
        reciepeItem.set_item_name(reciepe_name)
        var rec_icon = load(self.reciepes[reciepe_name].icon)
        if rec_icon:
            reciepeItem.set_item_img(rec_icon)
        var buildable = self.player.CraftStation.can_build(self.reciepes[reciepe_name])
        reciepeItem.set_disabled(not buildable)
        $Reciepes.add_child(reciepeItem)
        reciepeItem.connect('selected', self, '_on_reciepe_selected')
        
        
func _process(delta):
    self.reciepes = crafts.get_crafts()
    self.update_reciepes_view(self.player._get_inventory())
        
        
func update_reciepes_view(new_inventory):
    $Items/ItemList.clear()
    $Items/Counts.clear()
    render_ingridients(new_inventory)
    
    for ch in $Reciepes.get_children():
        var buildable = self.player.CraftStation.can_build(self.reciepes[ch.get_item_name()])
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
