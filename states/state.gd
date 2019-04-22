extends Node
var debug_print_timeout = 0
var inited = false
var host = null

func init(host):
    self.host = host
    inited = true
    return self
    
func update(delta):
    debug_print_timeout += delta
    assert inited and "State " + str(self) + " should be initialized with 'init'"
    

func throttle_print(args):
    if debug_print_timeout > 1:
        debug_print_timeout = 0
        print_debug(args)
        
func target_near_fear_area(target, fp):
    return target and fp and (target.position - fp.position).length() < fp.fear_radius