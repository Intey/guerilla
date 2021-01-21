extends Control

signal item_activated(item)

export var name_left := false
func _ready():
    if not name_left:
        move_child($Counts, 0)
    $ItemList.connect("item_activated", self, "__on_item_activated")
        

func join(target_inventory: Inventory):
    print_debug("join inventory")
    assert(target_inventory.connect('update', self, "update_reciepes_view") == OK)
    # initialize items when connect. Join can run after "update" signal
    update_reciepes_view(target_inventory.inventory)

    
func update_reciepes_view(new_inventory: Dictionary):
    $ItemList.clear()
    $Counts.clear()
    render_ingridients(new_inventory)

    
func render_ingridients(inventory: Dictionary):    
    print_debug("render ingridients", inventory) 
    if not inventory.empty():
        for item_name in inventory:
            _add_ingridient(item_name, inventory[item_name])  
    else:
        print_debug("connected inventory empty", inventory)
            
            
func _add_ingridient(name: String, count: int):
        $ItemList.add_item(name)
        $Counts.add_item(String(count))
        $Counts.set_item_disabled(len($Counts.items) - 1, true)

func __on_item_activated(idx):
    var items = $ItemList.get_selected_items()
    for i in items:
        emit_signal("item_activated", $ItemList.get_item_text(i))

func has_selected() -> bool:
    return $ItemList.is_anything_selected()

func get_selected():
    var items = []
    for i in $ItemList.get_selected_items():
        items.append($ItemList.get_item_text(i))
    return items
