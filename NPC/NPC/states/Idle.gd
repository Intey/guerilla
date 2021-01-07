extends FSMState


var target_direction 

func update_impl(delta):
    if self.host.view_enemy():
        self.host.nearest_enemy = self.host.visible_enemies[0]
        var min_pos = self.host.global_position.distance_to(self.host.nearest_enemy.global_position)
        for enemy in self.host.visible_enemies:
            var nd = self.host.global_position.distance_to(enemy.global_position)
            if nd < min_pos:
                min_pos = nd
                self.host.nearest_enemy = enemy
        return self.host.PURSUIT_STATE

func physics_process_impl(delta):
    pass
#    var host = self.host
#    target_direction = self.select_direction()
#    # TODO: remember path or came_from point, or last point. 
#    # move until not find other farest_direction in other direction
#    var velocity_dir = (target_direction - host.global_position).normalized()
#    self.host.move_and_slide(velocity_dir * host.speed)

func select_direction() -> Vector2:
    return find_farest_visible_direction()
    
    
func find_farest_visible_direction() -> Vector2:
    var host = self.host
    # var space_rid = get_world_2d().space
    # var space_state = Physics2DServer.space_get_direct_state(space_rid)
    var space_state = host.get_world_2d().direct_space_state
    var excepts = [self]
    var max_direction = Vector2(cos(0), sin(0))
    var max_distance = 0
    
    var max_direction_angle = 0
    # RayCast each 5 degree - searching farest position
    for angle in range(0, 360, 5):
        var cast_to = Vector2(cos(angle), sin(angle))        
        var result = space_state.intersect_ray(host.global_position, cast_to, excepts)
        # check distance to found object
        if result:
            result = result.collider
            var distance = host.global_position.distance_to(result.global_position)
            if distance > max_distance:
                max_direction_angle = angle
                # print_debug("angle for farest direction ", angle)
                max_direction = result.global_position
                max_distance = distance
        else:
            # roll the dice for random degree - prevent all pawns to move in
            # one direction. set this ange as max direction.
            pass 
    
    # prevent movent forward-backward
    if target_direction != null:
        var angle = max_direction.dot(target_direction)
        # if angle has positive value - move in same direction
        if angle > 0:
            return max_direction
        # we get backward direction. ignore it
        else:
            return target_direction
    else:
        return max_direction
