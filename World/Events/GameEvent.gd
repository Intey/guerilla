extends Node
class_name GameEvent

# deley of event to really appers
export var delay_seconds = 1
# already waited dalay
var wait_sec = 0

export var spawnAreaPath := '/root/World/SpawnArea'
export var mainCampPath := '/root/World/MainCamp'
# is event should appers
var appears = false

var GT: GlobalTime

func _ready():
    GT = get_node('/root/World/GlobalTime')
    assert(GT != null)


func _process(delta):
    delta = GT.timespeed * delta
    self.process(delta)
    

func process(delta):
    if self.appears:
        self.wait_sec += delta
        if self.wait_sec >= delay_seconds:
            print_debug("event fire: ", self.name, " at ", GT.time)
            self.event()
            self.appears = false
    
    
func appear():
    print_debug("appears event: ", self.name, " at ", GT.time)
    self.appears = true


func event():
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
    world.add_child(ani)
    
    
func create_animal() -> Animal:
    var animal = load("res://Animal/Animal.tscn")
    var ani: Animal = animal.instance()
    var camp = get_node(mainCampPath)
    if not camp:
        print_debug("not camp found. random roam")
    else:
        print_debug("Camp position ", camp.global_position)
        ani.random_roam = false
        ani.roam_target = camp.global_position
    return ani