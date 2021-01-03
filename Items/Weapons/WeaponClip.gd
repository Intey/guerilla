extends Value

export(int) var reload_timeout = 1

signal clip_reload_start()
signal clip_reload_done(ammo_count)
signal clip_uploaded(value, max_value)
signal clip_value_change(value)
    
    
func _init():
    ._init()
   
 

func upload(maxv, v=null):
    """
    Initialize values of clip
    """
    if v == null:
        v = maxv
    max_value = maxv
    value = v
    emit_signal("clip_uploaded", v, maxv)
    
        
func get_one():
    if value > 0:
        value -= 1
        emit_signal("clip_value_change", value)
        return true
    return false

func reload():
    if not $ReloadTimer.is_stopped():
        return
    $ReloadTimer.stop()
    $ReloadTimer.start()
    emit_signal("clip_reload_start")
    

func _on_ReloadTimer_timeout():
    value = max_value
    emit_signal("clip_reload_done", value)
