extends Control

var game_time_speed_per_second = 5
var week_days = ["Mon.","Tue.","Wed.","Thu.","Fri.","Sat.","Sun."]
var seasons = ["spring", "summer", "fall", "winter"]
var clock_icon_index = 1


func _ready():
	PlayerData.connect("energy_changed",Callable(self,"set_energy_bar"))
	PlayerData.connect("health_changed",Callable(self,"set_health_bar"))
	PlayerData.connect("mana_changed",Callable(self,"set_mana_bar"))
	set_energy_bar()
	set_health_bar()
	set_mana_bar()
	set_current_time()


func set_mana_bar():
	$EnergyBars/ManaPgBar.max_value = 100
	$EnergyBars/ManaPgBar.value = PlayerData.player_data["mana"]


func set_energy_bar():
	$EnergyBars/EnergyPgBar.max_value = 100
	$EnergyBars/EnergyPgBar.value = PlayerData.player_data["energy"]


func set_health_bar():
	$EnergyBars/HealthPgBar.max_value = 100
	$EnergyBars/HealthPgBar.value = PlayerData.player_data["health"]


func set_current_time():
	pass
#	$DateTime/Day.text = PlayerData.player_data["day_week"] + " " +  str(PlayerData.player_data["day_number"])
#	$DateTime/Time.text = return_adjusted_time_string(PlayerData.player_data["time_hours"],PlayerData.player_data["time_minutes"])
#	$DateTime/SeasonIcon.texture = load("res://Assets/Images/User interface/DateTime/season icons/"+ PlayerData.player_data["season"] +".png")
#	advance_clock_icon()


func return_adjusted_time_string(hours,minutes):
	if minutes == 0:
		minutes = "00"
	elif minutes == 5:
		minutes = "05"
	else:
		minutes = str(minutes)
	if hours < 12:
		return str(hours) + ":" + minutes + "a.m."
	elif hours == 12:
		return str(hours) + ":" + minutes + "p.m."
	elif hours < 24:
		return str(hours-12) + ":" + minutes + "p.m."
	elif hours == 24:
		return str(hours-12) + ":" + minutes + "a.m."


func advance_clock_icon():
	clock_icon_index += 1
	if clock_icon_index == 9:
		clock_icon_index = 1
	$DateTime/ClockIcon.texture = load("res://Assets/Images/User interface/DateTime/clock icons/"+str(clock_icon_index)+".png")


func _on_mana_timer_timeout():
	PlayerData.player_data["mana"] += 1
	if PlayerData.player_data["mana"] > 100:
		PlayerData.player_data["mana"] = 100
	PlayerData.emit_signal("mana_changed")
	$EnergyBars/ManaPgBar.value = PlayerData.player_data["mana"]
