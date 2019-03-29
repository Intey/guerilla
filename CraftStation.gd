static func can_build(reciepe, inventory):
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        if inventory.get(res_name, 0) < count:
            return false
    return true
