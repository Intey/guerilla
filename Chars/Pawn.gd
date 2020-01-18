extends KinematicBody2D
class_name Pawn

enum Fraction {
    Neutral,
    Left,
    Right
}
    
    
export(Fraction) var fraction = Fraction.Neutral
export var speed := 100
var target_pos: Vector2


signal kills(victum)
signal inventory_update(inventory)


func shoot(delta, target: Vector2):
    var victum = $RangeWeapon.fire(delta, target)
    if not victum:
        return
    if not victum.unit.alive:
        emit_signal("kills", victum)

        
func subtract_from_inventory(res):
    return $Inventory.subtract(res)


func add_to_inventory(res):
    $Inventory.add(res)


func _get_inventory() -> Dictionary:
    return $Inventory.inventory


func set_move_to(pos: Vector2):
    # print_debug("set pawn move to ", pos)
    target_pos = pos

