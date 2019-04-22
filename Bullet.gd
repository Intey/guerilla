extends Sprite

var velocity = Vector2(0, -300)
export (float) var SPEED = 20

func _process(delta):
    move(delta)
    removeWhenOffScreen()

func move(delta):
    global_position += velocity * SPEED * delta

func removeWhenOffScreen():
    if $LifeTime.is_stopped():
        queue_free()
