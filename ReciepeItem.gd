tool
extends HBoxContainer
class_name ReciepeItem

export (String) var item_name setget set_item_name, get_item_name
export (Texture) var item_img setget set_item_img, get_item_img

signal selected(item)

var selected = false
var disabled = false

func set_selected(v):
    selected = v
    if v:
        modulate = Color(0, 1, 0)
    else:
        modulate = Color(1, 1, 1)
            
    
func set_item_name(val):
    if has_node("Label"):
        $Label.text = str(val)
    
func get_item_name():
    if has_node("Label"):
        return $Label.text
        
func set_item_img(val):
    if has_node("SomeImage"):
        $SomeImage.texture = val
    
func get_item_img():
    if has_node("SomeImage"):
        return $SomeImage.texture
        
func set_disabled(disabled: bool):
    print("set disabled ", disabled, " ", item_name)
    self.disabled = disabled
    if self.disabled:
          modulate = Color(0.1, 0.1, 0.1)

func hover(entered):
    if not self.disabled:
        if entered:
            modulate = Color(0, 0.3, 0)
        else:
            modulate = Color(1,1,1) if not selected else Color(0, 1, 0)

func _on_Item_mouse_entered():
    if not self.disabled:
        hover(true)

func _on_Item_mouse_exited():
    if not self.disabled:
        hover(false)

func _on_Item_gui_input(event: InputEvent):
    # FIXME: не обрабытывать при нажал-отвел-отпустил
    if not self.disabled:
        if event.is_action_released('ui_select'):
            emit_signal('selected', self)
        
