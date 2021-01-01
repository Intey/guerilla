extends Node2D

onready var lead = $Red.position
onready var white = $White.position
onready var green = $Green.position
onready var lead_dir = $LeadDir.position

var w_p = Vector2()
var g_p = Vector2()


func _ready():
    w_p = positionate_direction(lead_dir, lead, true, 35)
    g_p = positionate_direction(lead_dir, lead, true, 65)


func _draw():
    # base view
    # draw_line(Vector2(), red, Color(1, 1, 1))
    # draw_line(Vector2(), white, Color(1, 1, 1))
    # draw_line(Vector2(), green, Color(1, 1, 1))
    # draw_line(Vector2(), lead, Color(1, 1, 1))
    # draw_line(Vector2(), lead_dir, Color(1, 1, 1))
    # draw_line(Vector2(), lead_dir - lead, Color(1, 1, 1))

    # draw_line(lead, lead_dir, Color(0, 0.5, 1))
    # draw_line(lead, white, Color(1, 0, 0))
    # draw_line(green, white, Color(0, 1, 0))
    # draw_line(green, lead, Color(0, 0, 1))

    # var d = lead_dir - lead
    # var p = lead + (lead - lead_dir).tangent()
    # draw_line(lead, p, Color(1, 0.5, 0.5))
    # p = lead - (lead - lead_dir).tangent()
    # draw_line(lead, p, Color(1, 0.5, 0.5))

    draw_circle(Vector2(), 3, Color(0, 0, 0))


func _process(delta):
    update()


func _physics_process(delta):
    var d = $White.position.distance_to(w_p)

    if d > 3:
        $White.position += (w_p - white).normalized() * 2

    d = $Green.position.distance_to(g_p)
    if d > 3:
        $Green.position += (g_p - green).normalized() * 2


func positionate_direction(lead_dir: Vector2, lead: Vector2, 
                           left: bool, distance: int, deg=90):
    var d = lead_dir - lead

    var m = d.normalized()
    var angle = deg2rad(180 + deg)
    if left:
        angle = deg2rad(180 - deg)

    m = lead + m.rotated(angle) * distance

    return m
