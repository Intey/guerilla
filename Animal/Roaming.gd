extends 'res://Animal/BaseState.gd'
var utils = preload("res://Utility/utils.gd").new()
var last_farest_direction: Vector2

func update_impl(delta):
    var host = self.host
    var fp = host.BB.get('fear_point')
    var target = host.BB.get('player')
    if fp and host.too_close(fp):
        utils.throttle_print("STOP ROAM. FLEE")    
        return host.FLEEING    
    if target_near_fear_area(target, fp):
        return host.WAIT
    if target:
        return host.PURSUIT
    
    roaming(delta)
    
func roaming(delta):
    var host = self.host
    
    # var host = get_parent().get_parent()
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
    host.velocity = last_farest_direction * host.speed

func physics_process_impl(delta):
    host.move(delta, host.velocity)
    
func find_farest_visible_direction():
    var host = self.host
    var fp = host.BB.get('fear_point')
    # var space_rid = get_world_2d().space
    # var space_state = Physics2DServer.space_get_direct_state(space_rid)
    var space_state = host.get_world_2d().direct_space_state
    var excepts = [self]
    var max_direction = Vector2(cos(0), sin(0))
    var max_distance = 0
    
    for angle in range(0, 360, 5):
        #print_debug('cast ray to angle ', angle)
        var cast_to = Vector2(cos(angle), sin(angle))
        var result = space_state.intersect_ray(host.global_position, cast_to, excepts)
        if result:
            var distance = abs((result.position - host.global_position).length())
            if distance > max_distance:
                #print_debug('find max distance ', distance, ' ', result.position, ' collide ray ', result.collider.name)
                max_direction = result.position
                max_distance = distance
    return max_direction.normalized()