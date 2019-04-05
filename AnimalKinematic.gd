extends KinematicBody2D

export var speed: float = 100.0

enum { ROAMING, PURSUIT }
var state: int = ROAMING
var target = null
var last_farest_direction: Vector2
var velocity: Vector2


func move(delta, velocity):
    var collision = move_and_collide(velocity * delta)
    #if collision:
    #    print_debug('collide ', collision)
    #print_debug("go to ", last_farest_direction)


func _draw():
    if state == ROAMING:
        $ColorRect.color = Color(0, 1, 1)
    else:
        $ColorRect.color = Color(1, 0, 0)
    draw_line(Vector2(), velocity * 20, Color(0,1,0))
    if target != null:
        var pos = target.position - position
        draw_line(Vector2(), pos, Color(1,0,0))
     
func _physics_process(delta):
    update()
    if state == ROAMING:
        #print_debug('roaming...')
        var farest_direction = find_farest_visible_direction()
        if not last_farest_direction:
            last_farest_direction = farest_direction
        # Если новая позиция примерно в нашей области зрения - идем к ней
        # чтобы не ходить вперед-назад
        var angle = farest_direction.dot(last_farest_direction)
        if angle > 0:
            last_farest_direction = farest_direction
        # remember path or came_from point, or last point. 
        # move until not find other farest_direction in other direction
        velocity = last_farest_direction * speed
        move(delta, velocity)
        
    elif state == PURSUIT:
        #print_debug('persuit ', target.position)
        var pos = target.position - position
        velocity = pos.normalized() * speed
        move(delta, velocity)
        
    
func find_farest_visible_direction():
    # var space_rid = get_world_2d().space
    # var space_state = Physics2DServer.space_get_direct_state(space_rid)
    var space_state = get_world_2d().direct_space_state
    var excepts = [self]
    var max_direction = Vector2(cos(0), sin(0))
    var max_distance = 0
    
    for angle in range(0, 360, 5):
        #print_debug('cast ray to angle ', angle)
        var cast_to = Vector2(cos(angle), sin(angle))
        var result = space_state.intersect_ray(global_position, cast_to, excepts)
        if result:
            var distance = abs((result.position - global_position).length())
            if distance > max_distance:
                #print_debug('find max distance ', distance, ' ', result.position, ' collide ray ', result.collider.name)
                max_direction = result.position
                max_distance = distance
    return max_direction.normalized()
    

func _on_DetectionArea_body_entered(body):
    print_debug(body.name)
    if body.name == 'PlayerBody':
        target = body
        state = PURSUIT
    
   
func _on_DetectionArea_body_exited(body):
    target = null
    state = ROAMING
