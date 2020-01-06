extends Node
class_name TroopSystem

var troops = []


func create_troop(teammates):
    var t = []
    for tm in teammates:
        t.append(tm)
    var troop = Troop.new(t)
    troops.append(troop)
    
    for pawn in troop.teammates:
        if not pawn is Pawn:
            print_debug("not pawn in troop system ", pawn.name)
            continue
            
        var ai = TroopAI.instance()
        ai.set_troop(troop)
        pawn.add_child(ai)
        
        #var vv = pawn.get_child("ViewArea")
        #vv.connect("body_entered", ai, "detect_body")
        
        
    