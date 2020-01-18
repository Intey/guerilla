extends "res://states/state.gd"

func update_impl(delta):
      
    # collecting
    if Input.is_action_just_pressed('ui_interact'):
        if self.host.collectable_area:
            return self.host.COLLECTING
        elif self.host.Blackboard.get("sleep"):
            return self.host.SLEEP
    if Input.is_action_just_pressed('ui_select'):
        if self.host.Blackboard.get('crafting'):
            if self.host.build_plan and not self.host.build_plan['node'].collided:
                self.host.build_structure()
        else:
            self.host.fire(delta)
    if Input.is_action_just_released("ui_untroop"):
        print_debug("untroop")
        troopsManager.untroop(self.host)

    elif Input.is_action_just_released("ui_troop"):
        print_debug("craete troop")
        # search nearest pawns
        var p1 = $"/root/World/Pawn"
        var p2 = $"/root/World/Pawn2"
        troopsManager.create_troop([self.host, p1, p2])
            
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
    velocity = velocity.normalized() * self.host.speed
    return velocity
    
func physics_process_impl(delta):
     var velocity = get_input()
     var collision = self.host.move_and_collide(velocity * delta)
    
