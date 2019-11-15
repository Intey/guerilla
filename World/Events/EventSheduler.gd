extends Node
class_name EventSheduler

var GT: GlobalTime
# events by it's time
var upcoming_events = {}

var inprogress_events = []
func _ready():
    GT = get_node('/root/World/GlobalTime')
    assert(GT != null)
    # TODO: load json with eventing and create them
    # TODO: skip done events(by globaltime)
    # TODO: run events, that already in progress(load game)
    upcoming_events = {}
    # timeout from start
    var event = GameEvent.new()
    self.add_child(event)
    upcoming_events[2] = event
    
    
func _process(delta):
    for time in self.upcoming_events:
        if time <= GT.time:
            self.upcoming_events[time].appear() 
            self.inprogress_events.append(self.upcoming_events[time])
            self.upcoming_events.erase(time)
            
    