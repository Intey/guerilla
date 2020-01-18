extends Node
"""
create move directions for pawns, that they can use for change it's position
"""

# how to format Line: make line 
#
var lead_prev_pos = {}
var lead_move_from_pos: Vector2

var update_time = 0.0
var last_update = 0


class Sorter:
    func sort(a, b):
        return a['distance'] < b['distance'] # a >= b -> swap


func _physics_process(delta):
    # throttle
    last_update += delta
    if last_update < update_time:
        return
    last_update = 0

    for troop in troopsManager.troops:
        var lead_pos = troop.leader.position
        if lead_prev_pos.get(troop) == null:
            # print_debug("lead not moved ", lead_pos)
            for pawn in troop.teammates:
                pawn.set_move_to(troop.leader.position)
        else:
            if lead_prev_pos[troop] == lead_pos:
                return
            lead_move_from_pos = lead_prev_pos[troop] 

            # print_debug("lead moves from ", lead_move_from_pos, " to ", lead_pos)
            var followers = len(troop.teammates)
            # var formation = __create_formation_by_distance(troop.teammates, lead_pos)
            # # position on map by environment situation (hidings, Arrow
            # # formation, etc.)
            # var formation_len := len(formation)
            # var formation_half: int = 0 
            # if formation_len % 2 == 0:
            #     formation_half = round(formation_len / 2)
            # else:
            #     formation_half = round((formation_len + 1) / 2)

            #for i in range(formation_len):
            var angle: int
            if troop.formation() == Troop.Formation.Line:
                angle = 90
            else:
                angle = 45

            var formation_half: int = 0 
            if followers % 2 == 0:
                formation_half = round(followers / 2)
            else:
                formation_half = round((followers + 1) / 2)

            for i in range(followers):
                var distance = 65 * (i + 1)
                var pawn = troop.teammates[i]
                var left = i > formation_half
                var pos = __positionate_direction(lead_move_from_pos, 
                            lead_pos, left, distance, angle)
                pawn.set_move_to(pos)
        
        lead_prev_pos[troop] = lead_pos


func __positionate_direction(lead_dir: Vector2, lead: Vector2, 
                           left: bool, distance: int, deg=90):
    var d = lead_dir - lead

    var m = d.normalized()
    var angle = deg2rad(180 + deg)
    if left:
        angle = deg2rad(180 - deg)

    m = lead + m.rotated(angle) * distance

    return m


func __create_formation_by_distance(pawns, lead_pos): 
    # formation is 1,...,lead,....n
    var formation = []
    var distances = []
    for pawn in pawns:
        var distance = pawn.position.distance_to(lead_pos)
        distances.push_back({'distance': distance, 'pawn': pawn})

    distances.sort_custom(Sorter, "sort")
    var lr = false
    for pawndist in distances:
        if lr:
            formation.push_back(pawndist['pawn'])
        else:
            formation.push_front(pawndist['pawn'])
        lr = not lr
    return formation


