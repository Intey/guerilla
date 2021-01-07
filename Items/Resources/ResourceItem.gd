extends Node
class_name ResourceItem
# name
var count := 0


func _to_string():
    return self.name + ":" + str(self.count)
