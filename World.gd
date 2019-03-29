extends Node2D


func _ready():
    $Player.connect('inventory_update', $HUD/CraftHUD, "update_state")
    $HUD/CraftHUD.connect('craft', $Player, 'on_craft')
    $HUD/CraftHUD.init($Player.inventory, $Player.crafts.get_crafts())

func _process(delta):
    if Input.is_action_just_released('create_campfire'):
        $HUD/CraftHUD.update_state($Player.inventory)  
        $HUD/CraftHUD.show()
    if Input.is_action_just_pressed('ui_cancel'): # and craftHud != null:
        $HUD/CraftHUD.hide()
    