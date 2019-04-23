extends KinematicBody2D
class_name Player

const BULLET = preload('res://Bullet.tscn')

export var speed = 250
export var collection_speed = 1

var use_slide = true

var CraftStation = preload('res://CraftStation.gd')
var BuildPlan = preload('res://BuildPlan.tscn')
var crafts = preload('res://crafts.gd')

signal inventory_update(inventory)
signal build(reciepe, position)

var health := Health.new()

onready var weapon_clip := $WeaponClip

var inventory = {
    'sticks': 10,
    'logs': 3,
   }
#var craftHud = null
var collectable_area = null
var build_plan = null

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    weapon_clip.upload(10)

func _process(delta):
    update()
    actions(delta)
    
func _draw():
    var mpos = get_local_mouse_position()
    draw_circle(mpos, 3, Color(1, 0, 0))

func actions(delta):
    # collecting
    if Input.is_action_just_pressed('ui_accept') and collectable_area:
        print_debug("start collecting ", collectable_area.type)
        $CollectTimer.start()
    if Input.is_action_just_released('ui_accept'):
        $CollectTimer.stop()
    if Input.is_action_just_pressed('ui_select'):
        if build_plan:
            if not build_plan['node'].collided:
                build_structure()
        else:
            fire(delta)
        

func _on_CollectTimer_timeout():
    if Input.is_action_pressed('ui_accept') and collectable_area:
        var collected = collectable_area.pop(collection_speed)
        var res_type = collectable_area.type
        if res_type in inventory:
            inventory[res_type] += collected
        else:
            inventory[res_type] = collected
        print_debug('collected ', collected, ' ', res_type, ". now player has ", inventory)
        emit_signal('inventory_update', self.inventory)


func enter_collectable_area(area):
    print_debug('enter ', area)
    collectable_area = area


func exit_collectable_area(area):
    print_debug('exit ', area)
    collectable_area = null
    $CollectTimer.stop()
        

func craft(name):
    var reciepes = crafts.get_crafts()
    var reciepe = reciepes.get(name)
    if reciepe == null:
        print_debug('unknown reciepe ', name, ". Variants: ", reciepes.keys())
        return
    # check reciepe buildable
    print_debug("craft reciepe ", reciepe)
    if CraftStation.can_build(reciepe, self.inventory):
        if reciepe.type == crafts.Types.ITEM:
            subtract_from_inventory(reciepe)
            add_to_inventory(name, reciepe.count)
            
        elif reciepe.type == crafts.Types.BUILDING:
            var plan_node = BuildPlan.instance()
            build_plan = {'node': plan_node, 'reciepe': reciepe}
            plan_node.set_area(self, $BuildArea/Shape.shape.radius)
            get_parent().add_child(plan_node)
            # нам нужно показывать|скрывать дочерние спрайты. 
            # hide/show - не работает
            $BuildArea.visible = true
        

func add_to_inventory(name, count):
    if self.inventory.get(name) == null:
        self.inventory[name] = 0
    self.inventory[name] += count
    emit_signal('inventory_update', self.inventory)


func subtract_from_inventory(reciepe):
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        self.inventory[res_name] -= count
        if self.inventory[res_name] == 0:
            self.inventory.erase(res_name)
    emit_signal('inventory_update', self.inventory)
    
    
func build_structure():
    if build_plan == null:
        return
    var reciepe = build_plan['reciepe']
    subtract_from_inventory(reciepe)
    var position = build_plan['node'].position
    emit_signal('build', reciepe, position)
    if not CraftStation.can_build(reciepe, self.inventory):
        self.hide_build_mode()


func hide_build_mode():
    if build_plan:
        build_plan['node'].queue_free()
        build_plan = null
    # нам нужно показывать|скрывать дочерние спрайты. 
    # hide/show - не работает
    $BuildArea.visible = false

func get_input() -> Vector2:
    var velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y += 1
    if Input.is_action_pressed('ui_up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed
    return velocity
    
func _physics_process(delta):
    var velocity = get_input()
    var collision = move_and_collide(velocity * delta)
    #if collision:
        #print_debug('collide ', collision)
        
func fire(delta):
    if not weapon_clip.get_one():
        weapon_clip.reload()
        return
    
    # start view
    var mpos = get_local_mouse_position()
    var bullet = BULLET.instance()
    bullet.global_position = global_position
    bullet.velocity = mpos.normalized()
    get_parent().add_child(bullet)
    
    # logic
    var space_state = get_world_2d().direct_space_state
    var excepts = [self]
    var cast_to = get_global_mouse_position()
    var result = space_state.intersect_ray(global_position, cast_to, excepts)
    if result:
        bullet.path_end = result.position
        if result.collider.has_method('hit'):
            result.collider.hit()
            