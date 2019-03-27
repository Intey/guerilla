extends Node2D

export (PackedScene) var Campfire
export var speed = 200
export var collection_speed = 1

var CraftHUD = preload('res://CraftHUD.tscn')
var showedHUD = null

var crafts = preload('res://crafts.gd')

var inventory = {}

var collectable_area = null


func _process(delta):
    move(delta)
    actions(delta)


func move(delta):    
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
    self.position += velocity * delta


func actions(delta):
    if Input.is_action_just_released('create_campfire'):
        showedHUD = CraftHUD.instance()
        showedHUD.set_items(inventory)
        get_parent().add_child(showedHUD)
    
    if Input.is_action_just_pressed('ui_cancel') and showedHUD != null:
        showedHUD.free()
        showedHUD = null
        
    # collecting
    if Input.is_action_just_pressed('ui_accept') and collectable_area:
        print_debug("start collecting ", collectable_area.type)
        $CollectTimer.start()
    if Input.is_action_just_released('ui_select'):
        $CollectTimer.stop()


func _on_CollectTimer_timeout():
    if Input.is_action_pressed('ui_accept') and collectable_area:
        var collected = collectable_area.pop(collection_speed)
        var res_type = collectable_area.type
        if res_type in inventory:
            inventory[res_type] += collected
        else:
            inventory[res_type] = collected
        print_debug('collected ', collected, ' ', res_type, ". now player has ", inventory)


func enter_collectable_area(area):
    print_debug('enter ', area)
    collectable_area = area


func exit_collectable_area(area):
    print_debug('exit ', area)
    collectable_area = null
    $CollectTimer.stop()
        
        
func build(name):
    var reciepe = crafts.get(name)
    if reciepe == null:
        print_debug('unknown reciepe ', name)
    # check reciepe buildable
    for res_name in reciepe:
        var count = reciepe['resources'][res_name]
        if inventory.get(res_name, 0) < count:
            print_debug('not enought ', res_name, ' for build ' , name)
            
    for res_name in reciepe:
        var count = reciepe['resources'][res_name]
        inventory[res_name] -= count
        if inventory[res_name] == 0:
            inventory.erase(res_name)
