extends Control

var game_time_speed_per_second = 15
var week_days = ["Mon.","Tue.","Wed.","Thu.","Fri.","Sat.","Sun."]
var seasons = ["Spring", "Summer", "Fall", "Winter"]
var clock_icon_index = 1

func _ready():
	PlayerData.connect("energy_changed", self, "set_energy_bar")
	PlayerData.connect("health_changed", self, "set_health_bar")
	PlayerData.connect("mana_changed", self, "set_mana_bar")
	set_energy_bar()
	set_health_bar()
	set_mana_bar()
	$DateTime/SeasonIcon.texture = load("res://Assets/Images/Inventory UI/DateTime/season icons/"+ PlayerData.player_data["season"] +".png")
	
func set_mana_bar():
	$EnergyBars/ManaPgBar.max_value = 100
	$EnergyBars/ManaPgBar.value = PlayerData.player_data["mana"]
	
func set_energy_bar():
	$EnergyBars/EnergyPgBar.max_value = 100
	$EnergyBars/EnergyPgBar.value = PlayerData.player_data["energy"]
	
func set_health_bar():
	$EnergyBars/HealthPgBar.max_value = 100
	$EnergyBars/HealthPgBar.value = PlayerData.player_data["health"]

func set_date_time():
	$DateTime/Day.text = PlayerData.player_data["day_week"] + " " +  str(PlayerData.player_data["day_number"])
	$DateTime/Time.text = return_adjusted_time_string(PlayerData.player_data["time_hours"],PlayerData.player_data["time_minutes"])

func _on_AdvanceTime_timeout():
	PlayerData.player_data["time_minutes"] += game_time_speed_per_second
	if PlayerData.player_data["time_minutes"] == 60:
		PlayerData.player_data["time_minutes"] = 0
		PlayerData.player_data["time_hours"] += 1
		if PlayerData.player_data["time_hours"] == 6:
			PlayerData.emit_signal("set_day")
		elif PlayerData.player_data["time_hours"] == 18:
			PlayerData.emit_signal("set_night")
		elif PlayerData.player_data["time_hours"] == 24:
			advance_day()
		elif PlayerData.player_data["time_hours"] == 25:
			 PlayerData.player_data["time_hours"] = 1
	set_date_time()
	advance_clock_icon()
	
func advance_day():
	var index = week_days.find(PlayerData.player_data["day_week"])
	index += 1
	if index == 7:
		index = 0
	PlayerData.player_data["day_week"] = week_days[index] 
	PlayerData.player_data["day_number"] += 1
	if PlayerData.player_data["day_number"] == 31:
		advance_season()
		
		
func advance_season():
	var index = seasons.find(PlayerData.player_data["season"])
	index += 1
	if index == 4:
		index = 0
	var new_szn = seasons[index]
	PlayerData.player_data["season"] = new_szn
	$DateTime/SeasonIcon.texture = load("res://Assets/Images/Inventory UI/DateTime/season icons/"+ new_szn +".png")
	
	
func return_adjusted_time_string(hours,minutes):
	if minutes == 0:
		minutes = "00"
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
	$DateTime/ClockIcon.texture = load("res://Assets/Images/Inventory UI/DateTime/clock icons/"+str(clock_icon_index)+".png")
