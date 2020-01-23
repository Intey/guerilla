extends Node
class_name InitialGenerator


var NPCScene = preload("res://NPC/NPC/NPC.tscn")

var world = null
var left_camp = null
var right_camp = null

func _init(world, leftcamp, rightcamp):
    self.world = world
    self.left_camp = leftcamp 
    self.right_camp = rightcamp

func generate():
    # generate left
    for i in range(10):
        # TOOD: 
        # - pass weapons (eg. 3 melee, 7 ranged)
        generate_npc(Pawn.Fraction.Left)
    for i in range(10):
        generate_npc(Pawn.Fraction.Right)
        
func generate_npc(fraction):
    var pos = null
    if fraction == Pawn.Fraction.Left:
        pos = random_position_in(left_camp.get_node('Area/Shape'))
    elif fraction == Pawn.Fraction.Right:
        pos = random_position_in(right_camp.get_node('Area/Shape'))
    
    var npc = NPCScene.instance()
    
    npc.global_position = pos
    npc.fraction = fraction
    var weap = npc.get_node("RangeWeapon")
    weap.clipsize = 7
    weap.damage = 40
    weap.time_for_one_shoot = 0.5
    self.world.add_child(npc)
    
func random_position_in(shape):
    var pos = shape.global_position
    shape = shape.shape
    var min_x = pos.x
    var min_y = pos.y
    var max_x = pos.x
    var max_y = pos.y
    
    # print_debug("SHAPE:", shape)
    if shape is CircleShape2D:
        max_x += shape.radius
        min_x -= shape.radius
        max_y += shape.radius
        min_y -= shape.radius
    else:
        assert false
        
    var result: Vector2 = pos
    result.x = rand_range(min_x, max_x)
    result.y = rand_range(min_y, max_y)
    return result
    
    
    
    
    
