extends Area2D
export var type = 'Unknown'
export var count = 0    

func _on_Resource_body_entered(body):
    if body is Player:
        body.enter_collectable_area(self)

func _on_Resource_body_exited(body):
    if body is Player:
        body.exit_collectable_area(self)

# extract resource and delete node, if resources done
func pop(cnt):
    var result = cnt
    if count < cnt:
        result = count
    count -= cnt
    if count <= 0:
        self.queue_free()
    return result    
