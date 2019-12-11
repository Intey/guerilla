extends Node
var inited = false
var host = null
export var debug = false
var GT = null

func init(host):
    self.host = host
    inited = true
    return self
    
func _ready():
    self.GT = get_node('/root/World/GlobalTime')
    if self.GT == null:
        self.GT = load('res://World/GlobalTime.tscn').instance()
    if get_parent().get('debug') != null:
        self.debug = get_parent().debug or self.debug
    
func update(delta):
    assert inited and "State " + str(self) + " should be initialized with 'init'"
    
    delta = self.GT.timespeed * delta
    var new_state = self.update_impl(delta)
    if new_state:
        return new_state
    
func update_physics(delta):
    delta = self.GT.timespeed * delta
    physics_process_impl(delta)
    
func update_impl(delta):
    pass
    #print_debug("Not implemented state method 'update_impl' ", self.host.name, ".", self.name)
    
func physics_process_impl(delta):
    pass
    #print_debug("Not implemented state method 'physics_process_impl' ", self.host.name, ".", self.name)
    

func on_enter():
    pass
    
func on_exit():
    pass
    
func soft_transit(state) -> bool:
    return true