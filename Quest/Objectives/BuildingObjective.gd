extends Node
class_name BuildingObjective
var building_name
var place: Vector2

func _init(building_name, place: Vector2):
    self.building_name = building_name
    self.place = place
