extends KinematicBody2D

export var speed = 250
var use_slide = true


func get_input() -> Vector2:
    var velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y += 1
    if Input.is_action_pressed('ui_up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed
    return velocity
    
func _physics_process(delta):
    var velocity = get_input()
    var collision = move_and_collide(velocity * delta)
    if collision:
        print_debug('collide ', collision)