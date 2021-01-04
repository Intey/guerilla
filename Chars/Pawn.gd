extends KinematicBody2D
class_name Pawn

enum Fraction {
    Neutral,
    Left,
    Right
}
    
export(Fraction) var fraction = Fraction.Neutral
#warning-ignore:unused_class_variable
export var speed := 100
#warning-ignore:unused_class_variable
export var shoot_range := 100
export var shoot_rate: float = 0.5
export var THIRST_HEALTH_DIFF: float = -1.0
export var STARVATION_HEALTH_DIFF: float = -1.0

var health: AutoValue

var alive := true
var on_dead: FuncRef

var target_pos: Vector2
var Blackboard = preload("res://Utility/Blackboard.gd").new()


func enter_campfire_zone():
    self.Blackboard.check('campfire')

func exit_campfire_zone():
    self.Blackboard.uncheck('campfire')

signal kills(victum)
signal dead(this)


func _init():
    ._init()
    
func _ready():
    self.on_dead = funcref(self, "queue_free")
    $RangeWeapon.init(self)
    $RangeWeapon.time_for_one_shoot = self.shoot_rate
    # TODO: backcompat for old code
    self.health = $Health
    
    $Thirst.connect("value_at_bottom", self, "__start_thirsting")
    $Starving.connect("value_at_bottom", self, "__start_starving")
    $Thirst.connect("value_at_middle", self, "__stop_thirsting")
    $Starving.connect("value_at_middle", self, "__stop_starving")
    
func _process(delta):
    pass
    
func shoot(delta, target: Vector2):
    var victum = $RangeWeapon.fire(delta, target)
    if not victum:
        return
    if not victum.alive:
        emit_signal("kills", victum)

        
func subtract_from_inventory(res: ResourceItem):
    return $Inventory.subtract(res)


func add_to_inventory(res: ResourceItem):
    $Inventory.add(res)


func _get_inventory() -> Dictionary:
    return $Inventory.inventory


func set_move_to(pos: Vector2):
    # print_debug("set pawn move to ", pos)
    target_pos = pos

func is_enemy(pawn: Pawn) -> bool:
    return pawn.fraction != self.fraction


# TODO: reduce damage with defence value?
func take_damage(dmg: int):
    print_debug("take damage ", dmg)
    if not self.alive:
        return
    self.health.value -= dmg
    if self.health.value == 0:
        alive = false
        # after queue_free, we need to remove reference on this pawn from other
        # objects (in arrays e.g.)
        emit_signal("dead", self)
        self.queue_free()


func __start_thirsting():
    $Health.change_per_tick += THIRST_HEALTH_DIFF
    
func __stop_thirsting():
    $Health.change_per_tick -= THIRST_HEALTH_DIFF
    
func __start_starving():
    $Health.change_per_tick += STARVATION_HEALTH_DIFF
    
func __stop_starving():
    $Health.change_per_tick -= STARVATION_HEALTH_DIFF

func __appease():
    print_debug("appease")
    if $Thirst.value == 0:
        var item = ResourceItem.new()
        item.name = "water"
        item.count = 1
        if $Inventory.subtract(item):
            print_debug("appease thirst")
            $Thirst.set_value(100)
            $Thirst.set_delay(30)
            
    if $Starving.value == 0:
        var item = ResourceItem.new()
        item.name = "food"
        item.count = 1
        if $Inventory.subtract(item):
            print_debug("appease starve")
            $Starving.set_value(100)
