extends Node
static func get_crafts():
    var file = File.new()
    file.open('res://assets/crafts.json', file.READ)
    var reciepes = JSON.parse(file.get_as_text()).result
    file.close()
    return reciepes