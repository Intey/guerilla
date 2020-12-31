"""
Sector is square area, that aggregate some area of tiles, and describes map
chunks.
Camp Commanders gives tasks for troops to scout sectors. Troop can scan sector,
that mean, they should search all it's area. 
When troop scans sector, they can analize other sectors.

Sectors also can be used with minimap.
"""
extends Node
class_name Sector

var position: Vector2

var cols = 'QWERTYUIOPASDFGHJKLZXCVBNM'

var has_enemy := false


func _init(name: String, size: int):
    self.position = Sector.position_of(name, size)


func name(size):
    # convert position to A1 - Z26 name
    var row = self.position.x % size
    var col = cols[row]
    return col + str(row)


static func position_of(name: String, size: int) -> Vector2:
    var col = cols.index(name[0])
    var row = int(name[1])
    return Vector2(col * size, row * size)
