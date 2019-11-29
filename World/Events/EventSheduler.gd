extends Node
class_name EventSheduler

var GT: GlobalTime

# events to fire. Stores: superevent, with it's repeats, time, condition and other  
var upcoming_events = {}
var forever_events = {} # event, delay, starttime


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
    var repeat_delay = event_data.get('repeat_delay', 0)
    var start_time = event_data.get('starttime', 0)
    
    # create oneshot
    print_debug("prepare event ", event.name, " to shedule at ", start_time)
    if repeats >= 0:
        add_to_upcoming(event, start_time)
    else:
        add_to_forever(event, start_time, repeat_delay)
    # event should be possible to get nodes from tree    
    self.add_child(event)
    if repeats != null:
        for i in range(0, repeats):
            var delay = start_time + repeat_delay * (i + 1)
            add_to_upcoming(event, delay)
            
    
func add_to_upcoming(event, time):
    var exists = upcoming_events.get(time)
    if exists:
        exists.append(event)
    else:
        upcoming_events[time] = [event]
        
        
func add_to_forever(event, start_time, repeat_delay):
  self.forever_events[event] = {
      'last_fire': start_time,
      'repeat_delay': repeat_delay
  }
        
        
func create_spawn_event() -> Dictionary:
    var event = GameEvent.new()
    return {"event": event, "repeats": -1, 'repeat_delay': 8, 'starttime': 1}
    
    
func create_conditional_event() -> Dictionary:
    var event = ConditionalEvent.new()
    return {'event': event, 'repeats': -1, 'repeat_delay': 8, 'starttime': 2}
    
    
func _process(delta):
    for time in self.upcoming_events:
        if time <= GT.time:
            self.start_upcoming_events(time)
    for event in self.forever_events:
        var event_data = self.forever_events[event]
        var repeat_delay = event_data['repeat_delay']
        var last_fire = event_data['last_fire']
        var must_run = (GT.time - last_fire) / repeat_delay > 1
        if must_run:
            self.forever_events[event]['last_fire'] = GT.time
            event.start()
            print_debug("start event ", event.name, " at ", GT.time, " second")
        
            
func start_upcoming_events(time):
    var events = self.upcoming_events[time]
    # waiting events
    for e in events:
        if e.start():
            self.upcoming_events[time].erase(e)
            # TODO: remove from children repeatable events
            print_debug("start event ", e.name, " at ", time, " second")
