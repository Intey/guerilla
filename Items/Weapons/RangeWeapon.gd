extends Node



# TODO: initialize domain args from json
export var clipsize: int
export var damage: int
export var autoshoot: bool = false
export var time_for_one_shoot: float = 1.0
export var critical: int = 0.4

const BULLET = preload('Bullet.tscn')
onready var weapon_clip := $WeaponClip

var last_shoot := self.time_for_one_shoot
var global_position: Vector2
var host: Node2D

func init(host):
    self.host = host
    weapon_clip.max_value = clipsize
    weapon_clip.value = clipsize
    
func _process(delta):
    last_shoot += delta
    
func fire(delta, target: Vector2):
    # last_shoot - seconds from last shoot
    # speed - shoot per second
    # get delta between shoots
    if last_shoot < time_for_one_shoot:
        return
        
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
    var excepts = [self.host]
    var cast_to = target
    var result = space_state.intersect_ray(global_position, cast_to, excepts)
    if result:
        bullet.path_end = result.position
        if result.collider.has_method('take_damage'):
            if randf() <= self.critical:
                result.collider.take_damage(result.collider.health.value)
            else:
                result.collider.take_damage(self.damage)
            return result.collider
