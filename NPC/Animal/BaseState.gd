extends FSMState

func target_near_fear_area(target, fp):
    return target and fp and (target.position - fp.position).length() < fp.fear_radius
