extends Node2D

func _ready():
    $HUD.join($Player)
    $Player/Thirst.tick_seconds = 1
    $Player/Thirst.change_per_tick = -40
    $Player.THIRST_HEALTH_DIFF = -11
    
    
    
    $Player/Starving.set_delay(100)
    $Player/Starving.change_per_tick = 0
    $Player.STARVATION_HEALTH_DIFF = -40
    
    $Player/AppeaseTimer.wait_time = 2
    
    $Player/Health.tick_seconds = 1
    
    var item = ResourceItem.new()
    item.name = "water"
    item.count = 2
    $Player/Inventory.add(item)
