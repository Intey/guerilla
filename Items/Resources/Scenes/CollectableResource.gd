"""
Base class for nodes, that renders on scene
"""
extends Area2D
class_name CollectableResource
export var type: String  # type is class of resource
export var count = 0    


# extract resource and delete node, if resources done
func pop(cnt) -> ResourceItem:
    var result = cnt
    if count < cnt:
        result = count
    count -= cnt
    if count <= 0:
        self.queue_free()
    print_debug("bitch")
    var res = ResourceItem.new(type, result)
    return res

