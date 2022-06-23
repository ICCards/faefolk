extends Node2D

signal update_time

var day
var season = "Spring"
var time_elapsed = 1

func _ready():
	update_date()

func update_time(_time_elapsed):
	if time_elapsed != _time_elapsed:
		time_elapsed = _time_elapsed 
		$TimeLabel.text = adjusted_time(time_elapsed)

func update_date():
	if Server.num_day == 31:
		Server.num_day = 1
	$SeasonLabel.text = str(season + ", " + str(Server.num_day))
	
func adjusted_time(time_elapsed):
		var hour = (time_elapsed / 2) + 6
		var minute = (time_elapsed % 2) * 3
		if hour <= 11:
			day = "a.m."
		if hour >= 12:
			day = "p.m."
		if hour >= 24:
			day = "a.m."
		if time_elapsed == 36:
			Server.num_day += 1
			update_date()
		if hour >= 13 and hour < 25:
			hour -= 12
		if hour >= 25:
			hour -= 24
		return str(hour) + ":" + str(minute) + "0" + str(day)


