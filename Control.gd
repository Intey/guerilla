extends Control

signal hover(node)

func _on_Control_mouse_entered():
    emit hover(self)
