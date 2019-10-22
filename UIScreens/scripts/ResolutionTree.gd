extends Tree
func _init():
    var item = self.create_item()
    item.set_text(0, "Windowed")
    item = self.create_item()
    item.set_text(0, "Fullscreen")