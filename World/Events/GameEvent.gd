extends Node
class_name GameEvent


export var spawnAreaPath := '/root/World/SpawnArea'
export var mainCampPath := '/root/World/MainCamp'


func _ready():
    self.name = "Spawn 2 Animals" 


func start() -> bool:
    if self.predicate():
        self._run()
        return true
    else:
        return false


func _run():
    spawn()
    spawn()
    

func spawn():
    var world = $"/root/World"
    var player = world.get_node("Player")
    var area = get_node(spawnAreaPath)
    if not area:
        print_debug("not found area")
        get_tree().quit()   
    var ani = self.create_animal()
    area.spawn(ani)
    # set target position is itself. animals stay
    ani.set_roam_target(ani.global_position)
    world.add_child(ani)
    
    
func create_animal() -> Animal:
    var animal = load("res://Animal/Animal.tscn")
    var ani: Animal = animal.instance()
    var camp = get_node(mainCampPath)
    if not camp:
        print_debug("not camp found. random roam")
    else:
        ani.set_roam_target(camp.global_position)
    return ani
    
func predicate() -> bool:
    return true