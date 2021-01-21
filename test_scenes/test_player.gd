extends Node2D

func _ready():
    $HUD.join($Player)
        
    $Player/AppeaseTimer.wait_time = 2
    $Player/Health.tick_seconds = 1
    check_corpse()
    
    
func check_thirst():
    $Player/Thirst.tick_seconds = 1
    $Player/Thirst.change_per_tick = -40
    $Player.THIRST_HEALTH_DIFF = -11
    
    var item = ResourceItem.new("water", 2)
    $Player/Inventory.add(item)

    
func check_starve():
    $Player/Starving.set_delay(100)
    $Player/Starving.change_per_tick = 0
    $Player.STARVATION_HEALTH_DIFF = -40

    
func check_corpse():
    $Corpse/Inventory.add_item("meat", 3)
    $Player.inventory.add_item("water", 2)
    $Player.inventory.add_item("bread", 2)
