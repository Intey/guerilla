extends ProgressBar


func start_reload():
    $AnimationPlayer.play("Reload")


func upload(v, maxv):
    value = v
    max_value = maxv
    var _animation = $AnimationPlayer.get_animation("Reload")


func reload_done(v):
    value = v
    $AnimationPlayer.stop()
    
    
func set_value(v):
    value = v
    
