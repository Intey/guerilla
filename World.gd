extends Node2D

onready var craftHud = $HUD/CraftHUD

func _ready():
    $Player.connect('inventory_update', craftHud, "update_state")
    craftHud.connect('craft', $Player, 'on_craft')
    craftHud.init($Player.inventory, $Player.crafts.get_crafts())

func _process(delta):
    if Input.is_action_just_released('create_campfire'):
        craftHud.update_state($Player.inventory)  
        craftHud.show()
    if Input.is_action_just_pressed('ui_cancel'): # and craftHud != null:
        craftHud.hide()
    