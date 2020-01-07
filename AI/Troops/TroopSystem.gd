extends Node
class_name TroopSystem

var TroopAIScene = preload("res://AI/Troops/TroopAI.tscn")
var troops = []
var pawns_troops = {}


func create_troop(teammates):
    var t = []
    for tm in teammates:
        # filter pawns, that already in some group
        if pawns_troops.get(tm) == null:
            t.append(tm)
        
    var troop = Troop.new(t)
    troops.append(troop)
    for tm in troop.teammates:
        pawns_troops[tm] = troop
    
    for pawn in troop.teammates:
        if not pawn is Pawn:
            print_debug("not pawn in troop system ", pawn.name)
            continue
        # add troop AI to pawn
        var ai = TroopAIScene.instance()
        ai.init(troop)
        pawn.add_child(ai)
        
        #var vv = pawn.get_child("ViewArea")
        #vv.connect("body_entered", ai, "detect_body")
        
        
    