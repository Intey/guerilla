
var player

func _init(player_):
    self.player = player_

func can_build(reciepe):
    var required_place = reciepe.get('place')
    if required_place and player.Blackboard != null and player.Blackboard.get(required_place) == null:
        return false
        
    for res_name in reciepe.ingridients:
        var count = reciepe.ingridients[res_name]
        if player._get_inventory().get(res_name, 0) < count:
            return false
    return true

func craft(reciepe):
    var count = reciepe.count
    var name = reciepe.name
    var result = ResourceItem.new(name, count)
    return result
