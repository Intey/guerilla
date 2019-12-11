extends Node
class_name KillObjective

var _count
var _target_type

signal completed()
signal changed(count)

var player

func _init(type, count):
    self._count = count
    self._target_type = type


func _ready():
    self.player = $"/root/World/Player"
    assert(self.player != null)
    self.bind()


func on_kills(target):
    if self._count == 0:
        return
    if target is self._target_type:
        self._count -= 1
        if self._count == 0:
            emit_signal("completed")
            return
        emit_signal("changed", self._count)

func bind():
    self.player.connect("kills", self, "on_kills")