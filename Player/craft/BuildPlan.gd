extends Node2D

var node: Node2D = null
var radius: float = 0

var color := Color(0.07, 0.56, 0.11, 0.77)
var collided := false


func _process(delta):
    # перемещаем план постройки в радиусе допустимой стройки
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


func _on_Area2D_area_entered(area):
    $ColorRect.color = Color(1, 0, 0.77)
    collided = true


func _on_Area2D_area_exited(area):
    $ColorRect.color = self.color
    collided = false