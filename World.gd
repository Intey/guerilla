extends Node2D

onready var craftHud = $HUD/CraftHUD
onready var ammoHud = $HUD/Ammo/ProgressBar

func _ready():
    connect_craft()
    connect_ammo()
    
func connect_craft():
    $Player.connect('inventory_update', craftHud, "update_state")
    craftHud.connect('craft', $Player, 'craft')
    craftHud.init($Player.inventory, $Player.crafts.get_crafts())
    $Player.connect('build', self, 'create_building')

func connect_ammo():
    var mv = $Player/Ammo.max_value
    var v = $Player/Ammo.value
    ammoHud.max_value = mv
    ammoHud.value = v
    
    $Player.connect("shoot", ammoHud, "set_value")

    
func _process(delta):
    if Input.is_action_just_released('create_campfire'):
        craftHud.update_state($Player.inventory)  
        craftHud.show()
    if Input.is_action_just_pressed('ui_cancel'): # and craftHud != null:
        craftHud.hide()
        $Player.hide_build_mode()
    
func create_building(reciepe, position):
    var scene_path = reciepe.scene
    var BuildScene = load(scene_path)
    var instance = BuildScene.instance()
    instance.position = position
    add_child(instance)

