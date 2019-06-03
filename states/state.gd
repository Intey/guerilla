extends Node
var debug_print_timeout = 0
var inited = false
var host = null

func init(host):
    self.host = host
    inited = true
    return self
    
func update(delta):
    assert inited and "State " + str(self) + " should be initialized with 'init'"
    debug_print_timeout += delta
    

func throttle_print(args):
    if debug_print_timeout > 1:
        debug_print_timeout = 0
        print_debug(args)
