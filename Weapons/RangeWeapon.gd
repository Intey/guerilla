extends Node

const BULLET = preload('res://Bullet.tscn')

onready var weapon_clip := $WeaponClip

export var bullets_per_second: int = 1 

var last_shoot := 0.0
var global_position: Vector2
var host: Node2D
var time_for_one_shoot: float = 1.0

func init(host):
    time_for_one_shoot = 1.0 / bullets_per_second
    self.host = host

func fire(delta, target: Vector2):
    last_shoot += delta
    # last_shoot - seconds from last shoot
    # speed - shoot per second
    # get delta between shoots
    if last_shoot < time_for_one_shoot:
        return
        
    print("shoot on ", last_shoot, " one: ", time_for_one_shoot)
    last_shoot = 0
    
    if not weapon_clip.get_one():
        weapon_clip.reload()
        return
    
    # start view

    var bullet = BULLET.instance()
    var global_position = host.global_position
    
    bullet.global_position = global_position
    
    var bullet_velocity = (target - global_position).normalized()

    bullet.velocity = bullet_velocity
    
    host.get_parent().add_child(bullet)
    # logic
    var space_state = host.get_world_2d().direct_space_state
    var excepts = [host]
    var cast_to = host.get_global_mouse_position()
    var result = space_state.intersect_ray(global_position, cast_to, excepts)
    if result:
        bullet.path_end = result.position
        if result.collider.has_method('hit'):
            result.collider.hit()