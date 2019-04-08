extends KinematicBody2D

export var speed: float = 100.0

enum { ROAMING, PURSUIT, FLEEING }
var state: int = ROAMING
var target = null
var last_farest_direction: Vector2
var velocity: Vector2
var nearest_campfire = null

class RoamingModel:
    var color = Color(0, 1, 1)
    func action(delta):
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
        
class PursuitModel:
    var color = Color(1, 0, 0)
    func action(delta):
        pursuit(delta)
        
class FleeingModel:
    var color = Color(0, 0, .5)
    func action(delta):
        velocity = (-nearest_campfire.position).normalized() * speed
        move(delta, velocity)
    
var models = {
    ROAMING: RoamingModel(),
    PURSUIT: PursuitModel(),
    FLEEING: FleeingModel(),
}


func move(delta, velocity):
    var collision = move_and_collide(velocity * delta)
    #if collision:
    #    print_debug('collide ', collision)
    #print_debug("go to ", last_farest_direction)


func _draw():
    $ColorRect.color = models[state].color
    draw_line(Vector2(), velocity * 20, Color(0,1,0))
    if target != null:
        var pos = target.position - position
        draw_line(Vector2(), pos, Color(1,0,0))
     
func _physics_process(delta):
    update()
    models[state].action(delta)
    
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

    
func pursuit(delta):
    #print_debug('persuit ', target.position)
    var pos = target.position - position
    velocity = pos.normalized() * speed
    move(delta, velocity)    
        
func _on_DetectionArea_body_entered(body):
    if body.name == 'Player' and state != FLEEING:
        target = body
        state = PURSUIT
    
   
func _on_DetectionArea_body_exited(body):
    target = null
    state = ROAMING


func _on_DetectionArea_area_entered(area):
    if area.name == "AnimalFearArea":
        state = FLEEING
        nearest_campfire = area.get_parent()
