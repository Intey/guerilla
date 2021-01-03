extends Value

func _init():
    ._init()
    
func init(maxv, v):
    max_value = maxv
    value = v
    
        
func shoot():
    value -= 1    
    
    
func empty():
    return self.value == 0
