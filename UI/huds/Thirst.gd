extends ProgressBar

func on_change(prev_value, new_value):
    print_debug("on change thirst:", prev_value, new_value)
    value = new_value

