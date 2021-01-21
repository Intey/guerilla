extends HBoxContainer

var left_inventory: Inventory = null
var right_inventory: Inventory = null

signal move_all_from_left()
signal move_all_from_right()

func join(left: Node2D, right: Player):
    $R/Label.text = right.name
    right_inventory = right.inventory
    $R/Right.join(right.inventory)
    $R/Right.connect("item_activated", self, "move_right_item")
    
    $L/Label.text = left.name
    left_inventory = left.inventory
    $L/Left.join(left.inventory)
    $L/Left.connect("item_activated", self, "move_left_item")
    
    $B/Right.connect("button_up", self, "move_right")
    $B/Left.connect("button_up", self, "move_left")
    

func move_left():
    
    __move_items(right_inventory, left_inventory, $R/Right)
    emit_signal("move_all_from_right")

    
func move_right():
    __move_items(left_inventory, right_inventory, $L/Left)
    emit_signal("move_all_from_left")
    

func __move_items(l, r, source_container):
    if source_container.has_selected():
        for item in source_container.get_selected():
            __move_item(l, r, item, l.get_count(item))
    else:
        var items = l.items()
        l.clear()
        for item in items:
            r.add(item)
        
func __move_item(l, r, item, count=1):
    if l.sub_item(item, count):
        r.add_item(item, count)
    
    
func move_left_item(item):
    __move_item(left_inventory, right_inventory, item)
    
func move_right_item(item):
    __move_item(right_inventory, left_inventory, item)
