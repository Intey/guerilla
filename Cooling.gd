extends Node

export(int) var reduce_timeout = 1
export(int) var reduce_count = 1
var inited = false
var host = null

func _ready():
    $Timer.wait_time = reduce_timeout

func init(host):
    self.host = host
    inited = true
    return self
    

func _on_Timer_timeout():
    assert inited and host and "Host should be set for Cooling"
    var env_cooling = host.BB.get('env_cooling')
    if env_cooling != null:
        reduce_count = env_cooling
