extends MarginContainer
var filepath = "res://settings.json"
var settings = {}

func _ready():
    settings['godmode'] = false
    $Opts/GodMode.pressed = settings['godmode']

func back():
    var file = File.new()
    file.open(filepath, File.WRITE)
    file.store_line(to_json(settings))
    file.close()
    get_tree().change_scene("res://UIScreens/MainMenu.tscn")


func _on_CheckButton_toggled(button_pressed):
    settings['godmode'] = button_pressed
