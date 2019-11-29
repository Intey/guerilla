extends Node2D

onready var craftHud = $HUD/CraftHUD
onready var ammoHud = $HUD/Ammo

func _ready():
    connect_craft()
    connect_clip()
    
func connect_craft():
    craftHud.init($Player)
    $Player.connect('inventory_update', craftHud, "update_reciepes_view")
    craftHud.connect('craft', $Player, 'craft')
    $Player.connect('build', self, 'create_building')
    

func connect_clip():
    var clip = $Player/RangeWeapon/WeaponClip
    var mv = clip.max_value
    var v = clip.value
    ammoHud.upload(v, mv)
    clip.connect("clip_uploaded", ammoHud, "upload")
    clip.connect("clip_value_change", ammoHud, "set_value")    
    clip.connect("clip_reload_done", ammoHud, "reload_done")
    clip.connect("clip_reload_start", ammoHud, "start_reload")
    
    
func _process(delta):
    if Input.is_action_just_released('open_craft'):
        $Player.Blackboard.check('crafting')
        craftHud.update_reciepes_view()  
        craftHud.show()
    if Input.is_action_just_pressed('ui_cancel'): # and craftHud != null:
        $Player.Blackboard.erase('crafting')
        craftHud.hide()
        $Player.hide_build_mode()
        
func create_building(reciepe, position):
    var scene_path = reciepe.scene
    var BuildScene = load(scene_path)
    var instance = BuildScene.instance()
    instance.position = position
    add_child(instance)

