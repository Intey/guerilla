extends Value
class_name AutoValue

export var change_per_tick := 0.0
export var tick_seconds := 100.0
var time_collector:= 0.0
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


func sync_state(with_emit: bool = true):
    last_state = state
    if value == max_value:
        state = State.TOP
        if state != last_state and with_emit:
            print("emit top")
            emit_signal("value_at_top")
    elif value == min_value:
        state = State.BOTTOM
        if state != last_state and with_emit:
            print("emit bottom")
            emit_signal("value_at_bottom")
    else:
        state = State.MIDDLE
        if state != last_state and with_emit:
            print("emit middle")
            emit_signal("value_at_middle")

func _init():
    sync_state(false)

func _process(delta):
    
    time_collector += delta
    if time_collector < tick_seconds:
        return
    print_debug("process autovalue ", self.name, " : ", change_per_tick)
    time_collector = 0.0
    .change(change_per_tick)
    sync_state()
