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
    print_debug("get gather objective: ", target, " but expect ", self._target_type)
    if target is self._target_type:
        self._count -= 1
        if self._count == 0:
            emit_signal("completed")
            return
        emit_signal("changed", self._count)

func bind(assignee: Pawn):
    """
    connect events from assign to quest handling
    """
    assert(assignee.connect("gathers", self, "on_get") == OK)
        
func on_reward(assignee):
    assignee.subtract_from_inventory(ResourceStick.new(self._count))

func _to_string():
    return "collect " + str(self._count) + " " + str(self._target_type)
