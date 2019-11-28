extends 'res://Animal/BaseState.gd'
var utils = preload("res://Utility/utils.gd").new()

# TODO: random roaming in area
export var target_direction: Vector2
export var random_roam: bool = true


func update_impl(delta):
    var host = self.host
    var fp = host.BB.get('fear_point')
    var target = host.BB.get('player')
    if fp and host.too_close(fp):
        utils.throttle_print(delta, "STOP ROAM. FLEE")    
        return host.FLEEING
    if target_near_fear_area(target, fp):
        return host.WAIT
    if target:
        return host.PURSUIT
    
    roaming(delta)
    
    
func roaming(delta):
    var host = self.host
    target_direction = self.select_direction()
    # TODO: remember path or came_from point, or last point. 
    # move until not find other farest_direction in other direction
    var velocity_dir = (target_direction - host.global_position).normalized()
    host.velocity = velocity_dir * host.speed

    
func physics_process_impl(delta):
    host.move(delta, host.velocity)
    
    
func select_direction() -> Vector2:
    if not random_roam:
        return self.target_direction
    else:
        return find_farest_visible_direction()
    
    
func find_farest_visible_direction() -> Vector2:
    var host = self.host
    var fp = host.BB.get('fear_point')
    # var space_rid = get_world_2d().space
    # var space_state = Physics2DServer.space_get_direct_state(space_rid)
    var space_state = host.get_world_2d().direct_space_state
    var excepts = [self]
    var max_direction = Vector2(cos(0), sin(0))
    var max_distance = 0
    
    var max_direction_angle = 0
    # RayCast на каждые 5 градусов, чтобы найти самую дальнюю позицию
    for angle in range(0, 360, 5):
        var cast_to = Vector2(cos(angle), sin(angle))        
        var result = space_state.intersect_ray(host.global_position, cast_to, excepts)
        # если есть коллизия - проверяем дистанцию до объекта 
        if result:
            var distance = host.global_position.distance_to(result.global_position)
            if distance > max_distance:
                max_direction_angle = angle
                print_debug("angle for farest direction ", angle)
                max_direction = result.global_position
                max_distance = distance
    
    # чтобы не ходить вперед-назад
    var angle = max_direction.dot(target_direction)
     # смотрим что новая позиция перед нами(в секторе на 180%)
    if angle > 0:
        return max_direction
    # Если где-то за нами - продолжаем идти вперед
    else:
        return target_direction