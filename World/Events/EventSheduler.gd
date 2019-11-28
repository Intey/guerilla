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
    var event = event_data['event']
    var repeats = event_data.get('repeats', 0)
    var between_delay = event_data.get('delay', 0)
    var first_delay = event_data.get('starttime', 0)
    
    # create oneshot
    upcoming_events[first_delay] = event
    # event should be possible to get nodes from tree    
    self.add_child(event)
    if repeats != null:
        for i in range(0, repeats):
            var delay = first_delay + between_delay * (i + 1)
            upcoming_events[delay] = event            
    #event = ConditionalEvent.new()
    #conditional_events.append(event)
    
    
func create_spawn_event() -> Dictionary:
    var event = GameEvent.new()
    return {"event": event, "repeats": 0, 'delay': 1, 'starttime': 1}
    
    
func _process(delta):
    for time in self.upcoming_events:
        if time <= GT.time:
            self.run_event(time)
            
func run_event(time):
    var e = self.upcoming_events[time]
    if e.start():
        self.upcoming_events.erase(time)
        print_debug("start event ", e.name, " at ", time, " second")
        