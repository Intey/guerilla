extends Node2D

var node: Node2D = null
var radius: float = 0


func _process(delta):
    var mouse_pos = get_global_mouse_position() 
    if node == null:
        position = mouse_pos
    else:
        # получаем вектор от игрока к мышке не длиннее 
        # радиуса и смещаем его на позицию игрока
        position = (mouse_pos - node.position).clamped(radius) + node.position

func set_area(near_node: Node2D, radius: float):
    self.node = near_node
    self.radius = radius
