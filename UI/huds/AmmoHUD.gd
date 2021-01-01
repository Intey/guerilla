extends Control


func start_reload():
    $AnimationPlayer.play("Reload")


func upload(v, maxv):
    $ProgressBar.value = v
    $ProgressBar.max_value = maxv
    var animation = $AnimationPlayer.get_animation("Reload")


func reload_done(v):
    $ProgressBar.value = v
    $AnimationPlayer.stop()
    
    
func set_value(v):
    $ProgressBar.value = v
    