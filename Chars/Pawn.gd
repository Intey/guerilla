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
        self.queue_free()


func __start_thirsting():
    $Health.change_per_tick += THIRST_HEALTH_DIFF


func __stop_thirsting():
    $Health.change_per_tick -= THIRST_HEALTH_DIFF


func __start_starving():
    $Health.change_per_tick += STARVATION_HEALTH_DIFF


func __stop_starving():
    $Health.change_per_tick -= STARVATION_HEALTH_DIFF

