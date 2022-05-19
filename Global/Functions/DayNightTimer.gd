extends Node

var day_timer:Timer
var night_timer:Timer
var is_daytime = true

var season = "Spring"
var day = 1
var hour = 6
var minute = 00



const LENGTH_OF_CYCLE = 24
const LENGTH_OF_TRANSITION = 8


signal advance_day
signal advance_season

func next_season(current_season):
	if current_season == "Spring":
		return "Summer"
	elif current_season == "Summer":
		return "Fall"
	elif current_season == "Fall":
		return "Winter"
	else:
		return "Spring"

func _ready():
	day_timer = Timer.new()
	day_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
	day_timer.one_shot = true
	add_child(day_timer)
	
	night_timer = Timer.new()
	night_timer.set_wait_time(LENGTH_OF_CYCLE / 2)
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
	day += 1
	if day == 10:
		day = 1
		season = next_season(season)
		emit_signal("advance_season")
	emit_signal("advance_day")
	yield(get_tree().create_timer(LENGTH_OF_TRANSITION), "timeout")
	start_day_timer()

