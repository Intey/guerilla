extends Node2D

func _ready():
    $HUD.join($Player)
    var gen = InitialGenerator.new(self, $LeftCamp, $RightCamp)
    gen.generate()
    
    
func create_building(reciepe, position):
    var scene_path = reciepe.scene
    var BuildScene = load(scene_path)
    var instance = BuildScene.instance()
    instance.position = position
    add_child(instance)
