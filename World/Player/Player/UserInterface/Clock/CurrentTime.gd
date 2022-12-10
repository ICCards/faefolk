extends Control

signal update_time
var day_number
var day_week
var time_minutes
var time_hours

func _ready():
	day_week = JsonData.player_data["day_week"]
	day_number = JsonData.player_data["day_number"]
	time_minutes = JsonData.player_data["time_minutes"] 
	time_hours = JsonData.player_data["time_hours"] 
	PlayerStats.connect("time_changed", self, "update_time")

func update_time():
	pass
#	if time_elapsed != _time_elapsed:
#		time_elapsed = _time_elapsed 
#		$TimeLabel.text = adjusted_time(time_elapsed)

func update_date():
	if day_number == 31:
		day_number = 1
	$Day.text = str(day_week + ", " + str(day_number))
	
#func adjusted_time(time_elapsed):
#		var hour = (time_elapsed / 2) + 6
#		var minute = (time_elapsed % 2) * 3
#		if hour <= 11:
#			day = "a.m."
#		if hour >= 12:
#			day = "p.m."
#		if hour >= 24:
#			day = "a.m."
#		if time_elapsed == 36:
#			Server.num_day += 1
#			update_date()
#		if hour >= 13 and hour < 25:
#			hour -= 12
#		if hour >= 25:
#			hour -= 24
#		return str(hour) + ":" + str(minute) + "0" + str(day)


#func save_world_data():
#	var file = File.new()
#	file.open(file_name,File.WRITE)
#	file.store_string(to_json(MapData.world))
#	file.close()
#	print("saved")
#	pass


func _on_Timer_timeout():
	$ClockHand.rotation_degrees += 6
