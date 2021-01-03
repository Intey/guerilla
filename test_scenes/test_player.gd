extends Node2D

func _ready():
    $HUD.join($Player)
    $Player/Thirst.tick_seconds = 1
    $Player/Thirst.change_per_tick = -1
    $Player.THIRST_HEALTH_DIFF = -1
    
    
    
    $Player/Starving.tick_seconds = 3
    $Player/Starving.change_per_tick = -2
    $Player.STARVATION_HEALTH_DIFF = -1
