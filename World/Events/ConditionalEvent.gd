extends Node
class_name ConditionalEvent


export var spawnAreaPath := '/root/World/SpawnArea'
export var mainCampPath := '/root/World/MainCamp'

var bodies = []
var expected_count = 3

func _ready():
    self.name = "Start Attack" 


func start() -> bool:
    if self.predicate():
        self._run()
        return true
    else:
        return false


func _run():
    var camp = get_node(mainCampPath)
    for body in self.bodies:
        print_debug("target body ", body, " to camp")
        body.set_roam_target(camp.global_position)
    
    
func predicate() -> bool:
    var area = get_node(self.spawnAreaPath)
    self.bodies = area.get_overlapping_bodies()
    return len(bodies) >= self.expected_count