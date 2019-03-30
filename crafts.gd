tool
extends Node

enum Types { 
    BUILDING=0, 
    ITEM=1 
}


static func read_json(path):
    var file = File.new()
    file.open(path, file.READ)
    var result = JSON.parse(file.get_as_text()).result
    file.close()
    return result


static func get_crafts():
    return read_json('res://assets/crafts.json')


static func get_types():
   return read_json('res://assets/types_map.json')
