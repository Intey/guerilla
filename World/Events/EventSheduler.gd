extends Node
class_name EventSheduler

var GT: GlobalTime
# events by it's time
var upcoming_events = {}
var conditional_events = []
var inprogress_events = []


func _ready():
    GT = get_node('/root/World/GlobalTime')
    assert(GT != null)
    # TODO: load json with eventing and create them
    # TODO: skip done events(by globaltime)
    # TODO: run events, that already in progress(load game)
    # timeout from start
    var event = GameEvent.new()
    self.add_child(event)
    upcoming_events[0] = event
    #event = ConditionalEvent.new()
    #conditional_events.append(event)
    
    
func _process(delta):
    for time in self.upcoming_events:
        if time <= GT.time:
            var event = self.upcoming_events[time]
            self.run_event(event)
            self.upcoming_events.erase(time)
            
    for e in self.conditional_events:
        if e.predicate():
            self.run_event(e)
            self.conditional_events.erase(e)
            
            
func run_event(e):
    e.appear()
    self.inprogress_events.append(e)