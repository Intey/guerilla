"""
Risky Commander sends it's scouts in battle mode.
"""

extends Node
class_name RiskyCommander
# analize data
# on low information - run scouting
# when know enemy position - select strategy, handle it
# create troops

# Main loop:
# * Analize exists data
# * run Scouts
# * Handle battles

var scouts = []
var battles = []
# chunks of map for scanning
var sector_size = 2000
var sectors = []
var nearest_enemy_sector: Sector
var passed_time = 0
var attack_troop: Troop


func _init():
    for col in Sector.cols:
        for i in range(len(Sector.cols)):
            var name = col + str(i+1)
            var sector = Sector.new(name, self.sector_size)
            sector.last_update = 10000
            self.sectors.append(sector)


func _process(delta):
    passed_time += delta

    # NOTE: maybe Timers?
    var todo = ""
    if self.passed_time >= 1 and self.passed_time - delta <= delta: 
        todo = analize()
    if self.passed_time >= 2 and self.passed_time - delta <= delta * 2:
        touch_sectors(delta)
        if todo == "scout":
            create_scout()
        elif todo == "attack":
            make_attack()
            pass 

    if self.passed_time >= 2:
        self.passed_time = 0


func create_scout():
    """
    Create scout group to sector from `select_scout_sector` 
    """
    var participants = search_participants()
    if len(participants) == 0:
        var lead = participants.pop_front()
        var target_sector = select_scout_sector()
        # TODO: pawn can has destination sector, not vector
        lead.target_pos = target_sector.position
        var troop = troopsManager.create_troop(lead, participants)
        # TODO: send with battle mode
        scouts.append({'troop': troop, 'sector': target_sector})


func search_participants():
    """
    return possible participants for some adventure
    """
    # TODO: process near area, select 1/3 pawns     return []
    return []


func select_scout_sector():
    """
    Returns sector, that should be scanned
    """
    var target = self.sectors[0]
    for s in self.sectors:
        if s.last_update > target.last_update:
            target = s
    self.sectors.erase(target)
    self.waiting_sectors.append(target)
    return target


func touch_sectors(delta):
    """
    Update sectors time to determine old sectors, that was scouted long time
    ago
    """

    for s in self.sectors:
        s.last_update += delta


func handle_scout_report(report):
    """
    ASYNC.

    Get scouts report. If scouts returned, ther return report about scouting of
    sector in that they was sended. 
    TODO: when scouts moves thay walk through other sectors and can analize
    them but partial.
    Report contains info abouts walked through sectors, target sector.
    """

    var sector = report['sector']
    var found_enemy = report['enemy']
    self.waiting_sectors.erase(sector)
    sector.last_update = 0
    self.secotrs.append(sector)


func analize():
    """
    Analize information, that commander has. By analize it's change self
    behaviour: 
    1. When enemy position unknown - spawn scouts.
    2. When we know enemy position - move army to attack
    """

    # find nearest sector with enemy
    var nearest_enemy_sector: Sector
    var current_position = self.pawn.global_position
    var dist = 0
    for s in self.sectors:
        if s.has_enemy():
            var new_dist = current_position.distance_to(s.position)
            if  new_dist < dist:
                dist = new_dist
                nearest_enemy_sector = s

    if nearest_enemy_sector:
        self.nearest_enemy_sector = nearest_enemy_sector
        return 'attack'
    else:
        self.nearest_enemy_sector = null
        return 'scout'


func make_attack():
    """
    Create troop with all pawns and send them to nearest enemy sector
    """

    var participants = [] # TODO: select all in camp
    if len(participants) == 0:
        return
    # craete main troop
    # TODO: use commander as lead of troop. Swap behaviour, Hierarhy FSM
    var lead = participants[0]
    lead.target_pos = self.nearest_enemy_sector.position
    self.attack_troop = troopsManager.create_troop(lead, participants)
