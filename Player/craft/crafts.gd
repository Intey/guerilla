tool
extends Node

enum Types { 
    BUILDING=0, 
    ITEM=1 
}

static func get_crafts():
    var reciepes: Dictionary = utils.read_json('res://assets/crafts.json')
    
    for reciepe_name in reciepes.keys():
        var reciepe = reciepes[reciepe_name]
        assert("count" in reciepe)
        assert("icon" in reciepe)
        assert("type" in reciepe)
        assert("ingridients" in reciepe)
        assert("scene" in reciepe)
        reciepe["name"] = reciepe_name
    return reciepes

static func get_types():
   return utils.read_json('res://assets/types_map.json')
