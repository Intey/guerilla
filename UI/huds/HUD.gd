extends Node


func join(player: Player):
    connect_craft(player)
    connect_clip(player)
    connect_health(player)
    connect_thirst(player)
    connect_starving(player)
    
    
func connect_craft(p):
    assert(p != null)
    var craftHud = $CL/CraftHUD
    craftHud.init(p)
    craftHud.hide()
    var inventory = p.get_node("Inventory")
    assert(inventory != null)
    assert(inventory.connect('update', craftHud, "update_reciepes_view") == OK)

    assert(craftHud.connect('craft', p, 'craft') == OK)
    assert(p.connect('build', self, 'create_building') == OK)
    assert(p.connect("craft_on", craftHud, "show") == OK)
    assert(p.connect("craft_off", craftHud, "hide") == OK)
    
    
func connect_clip(player):
    var clip = player.get_node("RangeWeapon/WeaponClip")
    assert(clip != null)
    
    var mv = clip.max_value
    var v = clip.value
    var ammoHud = $CL/MC/HB/VB/Ammo
    ammoHud.upload(v, mv)
    assert(clip.connect("clip_uploaded", ammoHud, "upload") == OK)
    assert(clip.connect("clip_value_change", ammoHud, "set_value") == OK)
    assert(clip.connect("clip_reload_done", ammoHud, "reload_done") == OK)
    assert(clip.connect("clip_reload_start", ammoHud, "start_reload") == OK)


func connect_health(player):    
    var hud_container = $CL/MC/HB/VB/Health
    var value_container = player.health
    assert(value_container != null)
    hud_container.value = value_container.value
    assert(value_container.connect("value_changed", hud_container, "on_change") == OK)


func connect_thirst(player):
    var hud_container = $CL/MC/HB/VB2/Thirst
    var value_container = player.get_node("Thirst")
    assert(value_container != null)
    hud_container.value = value_container.value
    assert(value_container.connect("value_changed", hud_container, "on_change") == OK)


func connect_starving(player):
    var hud_container = $CL/MC/HB/VB2/Starving
    var value_container = player.get_node("Starving")
    assert(value_container != null)
    hud_container.value = value_container.value
    assert(value_container.connect("value_changed", hud_container, "on_change") == OK)
