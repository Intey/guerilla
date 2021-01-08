extends Value
class_name AutoValue

export var change_per_tick: float = 0.0
export var tick_seconds: float = 1.0
var effects: Dictionary

#optimization
var summary_effect_change: float = 0.0

enum State {
    BOTTOM,
    MIDDLE,
    TOP
   }

var last_state: int
var state: int

signal value_at_bottom()
signal value_at_middle()
signal value_at_top()


func set_delay(seconds: float):
#    print_debug("delay autovalue ", self.name, " (", self.change_per_tick, ") on ", seconds)
    $Timer.set_paused(true)
    $DelayTimer.wait_time = seconds
    $DelayTimer.start()


func set_effect(name: String, value: float):
    effects[name] = value    
    summary_effect_change = 0.0
    for effect in effects:
        summary_effect_change += effects[effect]
    
    
func erase_effect(name: String):
    if effects.has(name):
        summary_effect_change -= effects[summary_effect_change]
        effects.erase(name)


func _init():
    __sync_state(false) # initialize state
    
    
func _ready():
    $Timer.wait_time = tick_seconds
    $Timer.set_paused(false)
    $Timer.one_shot = false
    $Timer.start()
    

func _on_Timer_timeout():
    var summary := 0.0
    for effect in effects:
        summary += effects[effect]
    assert (summary == summary_effect_change, "got you, bitch! Guards!")
#    print_debug(
#        "Autovalue(", 
#        self.name, 
#        ") Timer run decrement autovalue with effects: ", 
#        effects.keys(), 
#        "with summary effect:", 
#        summary_effect_change
#    )
    .change(change_per_tick + summary_effect_change)
    __sync_state()


func _on_DelayTimer_timeout():
#    print_debug("delay finished")
    $Timer.set_paused(false)


func __sync_state(with_emit: bool = true):
    last_state = state
    if value == max_value:
        state = State.TOP
        if state != last_state and with_emit:
            print_debug("emit top ", self.name)
            emit_signal("value_at_top")
    elif value == min_value:
        state = State.BOTTOM
        if state != last_state and with_emit:
            print_debug("emit bottom", self.name)
            emit_signal("value_at_bottom")
    else:
        state = State.MIDDLE
        if state != last_state and with_emit:
            print_debug("emit middle", self.name)
            emit_signal("value_at_middle")

