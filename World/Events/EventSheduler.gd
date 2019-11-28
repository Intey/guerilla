extends Node
class_name EventSheduler

var GT: GlobalTime

# events to fire. Stores: superevent, with it's repeats, time, condition and other  
var upcoming_events = {}

func _ready():
    GT = get_node('/root/World/GlobalTime')
    assert(GT != null)
    # TODO: load json with eventing and create them
    # TODO: skip done events(by globaltime)
    # TODO: run events, that already in progress(load game)
    # timeout from start
    var event_data = self.create_spawn_event()
    add_event(event_data)
    event_data = self.create_conditional_event()
    add_event(event_data)

    
func add_event(event_data):
    var event = event_data['event']
    var repeats = event_data.get('repeats', 0)
    var between_delay = event_data.get('repeat_delay', 0)
    var first_delay = event_data.get('starttime', 0)
    
    # create oneshot
    print_debug("prepare event ", event.name, " to shedule at ", first_delay)
    add_to_upcoming(event, first_delay)
    # event should be possible to get nodes from tree    
    self.add_child(event)
    if repeats != null:
        for i in range(0, repeats):
            var delay = first_delay + between_delay * (i + 1)
            add_to_upcoming(event, delay)
    
func add_to_upcoming(event, time):
    var exists = upcoming_events.get(time)
    if exists:
        exists.append(event)
    else:
        upcoming_events[time] = [event]
        
func create_spawn_event() -> Dictionary:
    var event = GameEvent.new()
    return {"event": event, "repeats": 1, 'repeat_delay': 1, 'starttime': 1}
    
func create_conditional_event() -> Dictionary:
    var event = ConditionalEvent.new()
    return {'event': event, 'repeats': 0}
    
func _process(delta):
    for time in self.upcoming_events:
        if time <= GT.time:
            self.run_event(time)
            
func run_event(time):
    var events = self.upcoming_events[time]
    # waiting events
    for e in events:
        if e.start():
            self.upcoming_events[time].erase(e)
            # TODO: remove from children repeatable events
            print_debug("start event ", e.name, " at ", time, " second")