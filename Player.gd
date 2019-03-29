extends Node2D

export (PackedScene) var Campfire
export var speed = 200
export var collection_speed = 1

var CraftHUD = preload('res://CraftHUD.tscn')
var showedHUD = null

var crafts = preload('res://crafts.gd')

var inventory = {}
var craftHud = null
var collectable_area = null

func _ready():
    pass
    
func on_craft(reciepe_name):
    build(reciepe_name)

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
        craftHud = CraftHUD.instance()
        craftHud.init(inventory, crafts.get_crafts())
        get_parent().add_child(craftHud)
        craftHud.connect('craft', self, 'on_craft')
    if Input.is_action_just_pressed('ui_cancel') and craftHud != null:
        craftHud.free()
        
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
    var reciepes = crafts.get_crafts()
    var reciepe = reciepes.get(name)
    if reciepe == null:
        print_debug('unknown reciepe ', name, ". Variants: ", reciepes.keys())
        return
    # check reciepe buildable
    print_debug("craft reciepe ", reciepe)
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        if inventory.get(res_name, 0) < count:
            print_debug('not enought ', res_name, ' for build ' , name)
            return
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        inventory[res_name] -= count
        if inventory[res_name] == 0:
            inventory.erase(res_name)
