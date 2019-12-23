extends KinematicBody2D
class_name Player

var settings_filepath = "res://settings.json"

const BULLET = preload('res://Bullet.tscn')

export var speed = 250
export var collection_speed = 1
export var max_sleep_time := 10.0
export var sleep_time := 10.0
export var shoot_range := 20

var inventory setget , _get_inventory

export var debug = false

var CS = preload('res://CraftStation.gd')
var BuildPlan = preload('res://BuildPlan.tscn')
var crafts = preload('res://crafts.gd')
var Blackboard = preload("res://Utility/Blackboard.gd").new()

signal inventory_update(inventory)
signal build(reciepe, position)
signal kills(victum)
signal gathers(resource)

var unit: Unit

# State machinary

var PREVIOUS = FSM.PREVIOUS_STATE
var IDLE = "idle"
var SLEEP = "sleep"
var COLLECTING = "collecting"

# Debug colors for state visibility
var colors = {
    IDLE: Color(0, 0, 0, 0),
    SLEEP: Color(0, 0, 1, 0.4),
    COLLECTING: Color(0, 0, 0, 0),
}
onready var states_map = {
    IDLE: $FSM/Idle.init(self),
    SLEEP: $FSM/Sleep.init(self),
    COLLECTING: $FSM/Collecting.init(self),
}

# ============ State machinary



#var craftHud = null
var collectable_area = null
var build_plan = null
var CraftStation = null
var godmode = false

func _ready():
    $FSM.init(states_map, IDLE)
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
    var color = colors.get($FSM.current_state, Color(1, 1, 1))
    $Sprite/ColorRect.color = color
    
    
#func _draw():
#    var mpos = get_local_mouse_position()
#    draw_circle(mpos, 3, Color(1, 0, 0))


func collect_item():
    var collected = collectable_area.pop(collection_speed)
    $Inventory.add(collected)
    emit_signal("gathers", collected)


func enter_collectable_area(area):
    if area is CollectableResource:
        print_debug('enter ', area)
        collectable_area = area


func exit_collectable_area(area):
    if area == collectable_area:
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
            for res_name in reciepe.ingridients:
                var count = reciepe.ingridients[res_name]
                var res = ResourceItem.new()
                res.name = res_name
                res.count = count
                self.subtract_from_inventory(res)
                
            var result = self.CraftStation.craft(reciepe)
            var res
            if name == "stick":
                res = ResourceStick.new(reciepe.count)
            else:
                res = ResourceItem.new()
                res.name = name
                res.count = reciepe.count
            $Inventory.add(res)
            
        elif reciepe.type == crafts.Types.BUILDING:
            var plan_node = BuildPlan.instance()
            build_plan = {'node': plan_node, 'reciepe': reciepe}
            plan_node.set_area(self, $BuildArea/Shape.shape.radius)
            get_parent().add_child(plan_node)
            # нам нужно показывать|скрывать дочерние спрайты. 
            # hide/show - не работает
            $BuildArea.visible = true
        

func subtract_from_inventory(res):
    return $Inventory.subtract(res)
            
    
func build_structure():
    if build_plan == null:
        return
    var reciepe = build_plan['reciepe']
    if not self.CraftStation.can_build(reciepe):
        self.hide_build_mode()
        return
        
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
    var victum = $RangeWeapon.fire(delta, mpos)
    if not victum:
        return
    if not victum.unit.alive:
        print_debug("player killed ", victum)
        emit_signal("kills", victum)
    
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
    
func _get_inventory():
    return $Inventory.inventory
