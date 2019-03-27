extends Node
static func get_crafts():
    return {
        'trap': {
            'resources': {
                'sticks': 10,
                'rope': 3,
                'mud': 1
            },
            'type': 'building'
        },
        'rope': {
            'resources': {    
                'leafs': 15,
            },
            'type': 'item'
        },
        'campfire': {
            'resources': {    
                'logs': 1,
                'sticks': 4    
            },
            'type': 'building'
        }
    }