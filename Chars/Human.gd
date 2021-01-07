extends Pawn
class_name Human

enum Fraction {
    Neutral,
    Left,
    Right
}

export(Fraction) var fraction = Fraction.Neutral

export var shoot_range := 100
export var shoot_rate: float = 0.5
var experience: Value


var target_pos: Vector2

var Blackboard = preload("res://Utility/Blackboard.gd").new()

func _ready():
    $RangeWeapon.init(self)
    $RangeWeapon.time_for_one_shoot = self.shoot_rate
    self.experience = $Experience


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


# TODO: remove set_move_to(pos) for troops from pawn.
# It's should be in troops AI/brain
func set_move_to(pos: Vector2):
    # print_debug("set pawn move to ", pos)
    target_pos = pos


func is_enemy(pawn: Human) -> bool:
    return pawn.fraction != self.fraction


func enter_campfire_zone():
    self.Blackboard.check('campfire')


func exit_campfire_zone():
    self.Blackboard.uncheck('campfire')


func _create_corpse() -> PackedScene:
    var corpse = ._create_corpse()
    corpse.loot = self._get_inventory()
    return corpse
    

func __on_check_appease():
    """
    Appease starvation or thirst needs with items in inventory
    """
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
            

