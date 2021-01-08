extends KinematicBody2D
class_name Pawn

#warning-ignore:unused_class_variable
export var speed := 100
#warning-ignore:unused_class_variable
var health: AutoValue

var alive := true
var on_dead: FuncRef

export var THIRST_HEALTH_DIFF: float = -1.0
export var STARVATION_HEALTH_DIFF: float = -1.0

var corpseScene = preload("res://Chars/Corpse.tscn")

signal kills(victum)
signal dead(this)


func _ready():
    self.on_dead = funcref(self, "queue_free")
    # for simple acceptance for HUD/Weapons
    self.health = $Health
    assert($Thirst.connect("value_at_bottom", self, "__start_thirsting") == OK)
    assert($Starving.connect("value_at_bottom", self, "__start_starving") == OK)
    assert($Thirst.connect("value_at_middle", self, "__stop_thirsting") == OK)
    assert($Starving.connect("value_at_middle", self, "__stop_starving") == OK)


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
        var corpse = _create_corpse()
        self.queue_free()
        var parent = get_parent()
        print_debug("parent ", parent.name)
        parent.add_child(corpse)
        
        
func _create_corpse() -> PackedScene:
    print_debug("corpse created")
    var corpse =  corpseScene.instance()
    corpse.global_position = self.global_position
    return corpse


func __start_thirsting():
    print_debug("start thirsting")
    $Health.set_effect("THIRST", THIRST_HEALTH_DIFF)


func __stop_thirsting():
    print_debug("stop thirsting")
    $Health.erase_effect("THIRST")


func __start_starving():
    print_debug("start starving")
    $Health.set_effect("STARVE", STARVATION_HEALTH_DIFF)


func __stop_starving():
    print_debug("stop starving")
    $Health.erase_effect("STARVE")

