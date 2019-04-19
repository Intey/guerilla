extends Node

var inited = false
var host = null

func init(host):
    self.host = host
    inited = true
    return self
    
func update(delta):
    assert inited and "State " + str(self) + " should be initialized with 'init'"