extends Node2D

func _ready():
    $HUD.join($Player)
    $Player/Thirst.tick_seconds = 1000
    $Player/Thirst.change_per_tick = 0
    $Player.THIRST_HEALTH_DIFF = -1
    
    
    $Player/Starving.tick_seconds = 5
    $Player/Starving.change_per_tick = -100
    $Player.STARVATION_HEALTH_DIFF = -40
