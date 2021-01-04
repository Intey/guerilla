extends Node2D

func _ready():
    $HUD.join($Player)
    $Player/Thirst.tick_seconds = 1
    $Player/Thirst.change_per_tick = -80
    $Player.THIRST_HEALTH_DIFF = -1
    
    
    $Player/Starving.tick_seconds = 300
    $Player/Starving.change_per_tick = 0
    $Player.STARVATION_HEALTH_DIFF = -40
    
    $Player/CheckStarvThirst.wait_time = 2
    
    var item = ResourceItem.new()
    item.name = "water"
    item.count = 2
    $Player/Inventory.add(item)
