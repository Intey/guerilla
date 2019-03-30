extends Node2D

onready var craftHud = $HUD/CraftHUD

func _ready():
    $Player.connect('inventory_update', craftHud, "update_state")
    craftHud.connect('craft', $Player, 'craft')
    craftHud.init($Player.inventory, $Player.crafts.get_crafts())
    $Player.connect('build', self, 'create_building')

func _process(delta):
    if Input.is_action_just_released('create_campfire'):
        craftHud.update_state($Player.inventory)  
        craftHud.show()
    if Input.is_action_just_pressed('ui_cancel'): # and craftHud != null:
        craftHud.hide()
        $Player.
    
func create_building(reciepe, position):
    var scene_path = reciepe.scene
    var BuildScene = load(scene_path)
    var instance = BuildScene.instance()
    instance.position = position
    add_child(instance)