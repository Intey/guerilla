extends Node
class_name ResourceItem
# name
var count := 0


func __str__():
    return self.name + ":" + str(self.count)
