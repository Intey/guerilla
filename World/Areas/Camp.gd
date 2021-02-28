extends Node2D

var buildings = []
export(Human.Fraction) var fraction


func _on_Area_area_entered(area):
    if area is Building:
        self.buildings.append(area)
        print_debug("add building to camp: ", area)
