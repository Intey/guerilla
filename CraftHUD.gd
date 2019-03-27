extends Panel

var crafts = preload('res://crafts.gd')
var Item = preload('res://Item.tscn')

var selected_item: Item = null

func _ready():
    for reciepe_name in crafts.get_crafts():
        var item = Item.instance()
        item.set_item_name(reciepe_name)
        $Reciepes.add_child(item)
        # var item = $CraftVariants.get_child(index)
        item.connect('selected', self, '_on_item_selected')        
        
func set_items(items):
    for item in items:
        add_item(item, items[item])

func add_item(name, count):
    $ItemList.add_item(name)
    $Counts.add_item(String(count))
    
func _on_item_selected(item: Item):
    $ResourceName.text = item.get_item_name()
    if selected_item:
        selected_item.set_selected(false)
    selected_item = item
    item.set_selected(true)