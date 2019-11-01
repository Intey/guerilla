extends "res://states/state.gd"

export var collecting_timeout = 1.0
var __collect_time = 0.0

func update(delta):
    .update(delta)
    if not Input.is_action_pressed('ui_interact'):
        return self.host.PREVIOUS
                
    __collect_time += delta
    if __collect_time > collecting_timeout:
        __collect_time = 0
        if self.host.collectable_area:
            var res_type = self.host.collectable_area.type
            self.host.collect_item(res_type)