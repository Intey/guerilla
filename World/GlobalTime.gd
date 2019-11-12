extends Node
class_name GlobalTime

class DateTime:
    func _init(day, month, year, hours=0, minutes=0, seconds=0, milliseconds=0):
        self.day = day
        self.month = month
        self.year = year
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    
    func __str__():
        return str(self.day) + "-" + str(self.month) + "-" + str(self.year) \
            + " " + str(self.hours) + ":" + str(self.minutes) + ":" + str(self.seconds) + ":" + str(self.milliseconds)
    
    static func from_str(s: String):
        var ss = s.split(' ')
        var date = ss[0]
        var time = ss[1]
        var dv = date.split('-')
        var tv = time.split(':')
        
        return DateTime.new(int(dv[0]), int(dv[1]), int(dv[2]), int(tv[0]), int(tv[1]), int(tv[2]), int(tv[3]))
        
export var time := 0.0
export var timespeed := 1.0
var last_second = 0

func _process(delta):
    # TODO: use player timelaps stamina
    if Input.is_action_just_pressed("ui_timelapse"):
        timespeed = 0.4
    if Input.is_action_just_released("ui_timelapse"):
        timespeed = 1.0
        
    var scaled_delta = delta * timespeed
    time += scaled_delta
    last_second += scaled_delta
    if last_second >= 1:
        print_debug("time is: ", time)
        last_second = 0
        
        
    