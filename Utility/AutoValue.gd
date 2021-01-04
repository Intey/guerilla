extends Value
class_name AutoValue

export var change_per_tick: float = 0.0
export var tick_seconds: int = 100
var delay_seconds: float = 0.0
var time_collector: float = 0.0

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


func set_delay(seconds: int):
    print_debug("auto change delayer for ", self.name, " of ", self.change_per_tick, " on ", self.delay_seconds)
    self.delay_seconds = seconds

func _init():
    __sync_state(false)


func _process(delta):
    if delay_seconds > 0:
#        print_debug("rest dalay ", self.delay_seconds)
        delay_seconds -= delta
        return
    else:
        delay_seconds = 0
    
    time_collector += delta
    if time_collector < tick_seconds:
        return
#    print_debug("process autovalue ", self.name, " : ", change_per_tick)
    time_collector = 0.0
    .change(change_per_tick)
    __sync_state()
    

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

