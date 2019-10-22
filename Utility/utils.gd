tool
extends Node
class_name utils

var debug_print_timeout = 0

func throttle_print(delta, args):
    return 
    debug_print_timeout += delta
    if debug_print_timeout > 1:
        debug_print_timeout = 0
        print_debug(args)