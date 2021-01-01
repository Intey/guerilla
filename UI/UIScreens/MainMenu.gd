extends MarginContainer

func start_game():
    get_tree().change_scene("res://World/World.tscn")

func options():
    get_tree().change_scene("res://UIScreens/Options.tscn")
