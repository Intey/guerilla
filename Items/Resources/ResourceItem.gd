extends Node
class_name ResourceItem
# name
var count := 0


func _init(name, count=0):
    self.name = name
    self.count = count
    

func _to_string():
    return self.name + ":" + str(self.count)
