extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var rnd = RandomNumberGenerator.new()

func _ready():
    rnd.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func spawn(instance):
    """
    Position node in this area
    """
    var x = rnd.randi_range($Shape.global_position.x, $Shape.global_position.x + $Shape.shape.extents.x)
    var y = rnd.randi_range($Shape.global_position.y, $Shape.global_position.y + $Shape.shape.extents.y)
    instance.global_position = Vector2(x, y)