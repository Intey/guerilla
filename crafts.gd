tool
extends Node

enum Types { 
    BUILDING=0, 
    ITEM=1 
}

static func get_crafts():
    return utils.read_json('res://assets/crafts.json')


static func get_types():
   return utils.read_json('res://assets/types_map.json')
