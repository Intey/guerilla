extends Node
class_name GatherObjective

var _count
var _target_type

signal completed()
signal changed(count)


func _init(type, count):
    self._count = count
    self._target_type = type


func on_get(target: ResourceItem):
    print_debug("gather objective", target)
    """
    When pawn gather resource
    """
    if self._count == 0:
        return
    if target is self._target_type:
        self._count -= 1
        if self._count == 0:
            emit_signal("completed")
            return
        emit_signal("changed", self._count)

func bind(assignee=null):
    if assignee == null:
        self.player.connect("gathers", self, "on_get")
    else:
        assignee.connect("gathers", self, "on_get")
        
func on_reward(assignee):
    assignee.subtract_from_inventory(ResourceStick.new(self._count))