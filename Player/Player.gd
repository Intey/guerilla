extends KinematicBody2D
class_name Player
var settings_filepath = "res://settings.json"

const BULLET = preload('res://Bullet.tscn')

export var speed = 250
export var collection_speed = 1
export var max_sleep_time := 10.0
export var sleep_time := 10.0
export var shoot_range := 20
export var debug = false

var CS = preload('res://CraftStation.gd')
var BuildPlan = preload('res://BuildPlan.tscn')
var crafts = preload('res://crafts.gd')
var Blackboard = preload("res://Utility/Blackboard.gd").new()

signal inventory_update(inventory)
signal build(reciepe, position)

var unit: Unit

# State machinary
enum {
    PREVIOUS = Machinary.PREVIOUS_STATE,
    IDLE,
    SLEEP,
    COLLECTING,
}
# Debug colors for state visibility
var colors = {
    IDLE: Color(0, 0, 0, 0),
    SLEEP: Color(0, 0, 1, 0.4),
    COLLECTING: Color(0, 0, 0, 0),
}
onready var states_map = {
    IDLE: $Machinary/Idle.init(self),
    SLEEP: $Machinary/Sleep.init(self),
    COLLECTING: $Machinary/Collecting.init(self),
}

# ============ State machinary


var inventory = {
    'sticks': 10,
    'logs': 3,
    'meat': 6,
    "leafs": 20,
   }
#var craftHud = null
var collectable_area = null
var build_plan = null
var CraftStation = null
var godmode = false

func _ready():
    $Machinary.init(states_map, IDLE)
    self.CraftStation = CS.new(self)
    var settings_file = File.new()
    settings_file.open(settings_filepath, File.READ)
    var line = settings_file.get_line()
    var settings = parse_json(line)
    godmode = settings.get('godmode', false)
    
    # TODO: Hide mouse when aiming, and enable on gui opened
    # Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

    unit = Unit.new(1000, funcref(self, "queue_free"))
    $RangeWeapon.init(self)
    
func _process(delta):
    self.update()
    $AnimationPlayer.play("idle")    
    
func _draw():
    var color = colors.get($Machinary.current_state, Color(1, 1, 1))
    $Sprite/ColorRect.color = color
    
#func _draw():
#    var mpos = get_local_mouse_position()
#    draw_circle(mpos, 3, Color(1, 0, 0))

func collect_item(res_type):
    var collected = collectable_area.pop(collection_speed)
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
        
func enter_campfire_zone():
    self.Blackboard.check('campfire')

func exit_campfire_zone():
    self.Blackboard.erase('campfire')

func set_sleep_zone(in_zone=true):
    if in_zone:
        self.Blackboard.check("sleep")    
    else:
        self.Blackboard.erase("sleep")

func craft(name):
    # CraftStation.craft(name)
    var reciepes = crafts.get_crafts()
    var reciepe = reciepes.get(name)
    if reciepe == null:
        print_debug('unknown reciepe ', name, ". Variants: ", reciepes.keys())
        return
    # check reciepe buildable
    print_debug("craft reciepe ", reciepe)
    if self.CraftStation.can_build(reciepe):
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
    if not self.CraftStation.can_build(reciepe):
        self.hide_build_mode()
    # TODO: add to camp


func hide_build_mode():
    if build_plan:
        build_plan['node'].queue_free()
        build_plan = null
    # нам нужно показывать|скрывать дочерние спрайты. 
    # hide/show - не работает
    $BuildArea.visible = false
    #if collision:
        #print_debug('collide ', collision)
        
func fire(delta):
    var mpos = get_local_mouse_position() * shoot_range
    $RangeWeapon.fire(delta, mpos)
    
func hit(dmg):
    if godmode:
        return 
    self.unit.take_damage(dmg)
    if not self.unit.alive:
        get_tree().change_scene("res://UIScreens/MainMenu.tscn")
        
func start_collect():
    $CollectTimer.start()
    
func stop_collect():
    $CollectTimer.stop()
