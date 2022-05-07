extends Node

var day_timer:Timer
var night_timer:Timer
var is_daytime = true

const LENGTH_OF_NIGHT_DAY = 3
const LENGTH_OF_TRANSITION = 8

func _ready():
	day_timer = Timer.new()
	day_timer.set_wait_time(LENGTH_OF_NIGHT_DAY)
	day_timer.one_shot = true
	add_child(day_timer)
	
	night_timer = Timer.new()
	night_timer.set_wait_time(LENGTH_OF_NIGHT_DAY)
	night_timer.one_shot = true
	add_child(night_timer)

func start_day_timer() -> void:
	day_timer.start()
	yield(day_timer, "timeout")
	is_daytime = false
	yield(get_tree().create_timer(LENGTH_OF_TRANSITION), "timeout")
	start_night_timer()
	
	
func start_night_timer() -> void:
	night_timer.start()
	yield(night_timer, "timeout")
	is_daytime = true
	yield(get_tree().create_timer(LENGTH_OF_TRANSITION), "timeout")
	start_day_timer()
