extends "res://states/state.gd"

var collecting_timeout: float = 1.0
var __collect_time = 0.0


func init(host):
    .init(host)
    self.collecting_timeout = 1.0 / self.host.collection_speed
    return self

func update_impl(delta):
    if not Input.is_action_pressed('ui_interact'):
        return self.host.PREVIOUS
    __collect_time += delta
    
    if __collect_time > self.collecting_timeout:
        __collect_time = 0
        self.host.collect_item()
