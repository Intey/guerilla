extends Node
class_name TroopSystem

var TroopAIScene = preload("res://AI/Troops/TroopAI/TroopAI.tscn")
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
            print_debug("not pawn in troop system " + pawn.name)
            continue
        # add troop AI to pawn
        var ai = TroopAIScene.instance()
        ai.init(troop)
        ai.teach(pawn)
        
        
func untroop(pawn: Pawn):
    var troop: Troop = get_troop_for(pawn)
    if troop == null:
        return
    
    for tm in troop.teammates:
        var ai = tm.find_node("TroopAI", true, false)
        if ai == null:
            print_debug("teammate has no AI")
        else:
            tm.remove_child(ai)
            ai.free()
        
    for p in troop.teammates:
        self.pawns_troops.erase(p)
    self.troops.erase(troop)   
            
            
func get_troop_for(pawn: Pawn) -> Troop:
    return self.pawns_troops.get(pawn)
    