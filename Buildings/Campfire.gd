extends Node2D

#export var width = 25
#export var height = 25
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export onready var fear_radius = $AnimalFearArea/Shape.shape.radius
export var camp_distance: float 
# Called when the node enters the scene tree for the first time.
func _ready():
    pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_CraftArea_body_entered(body):
    if body is Player:
        body.enter_campfire_zone()


func _on_CraftArea_body_exited(body):
    if body is Player:
        body.exit_campfire_zone()
