extends AudioStreamPlayer

var is_inside_storm = false
var storm1
var storm2


func _ready():
	Sounds.connect("volume_change",Callable(self,"set_new_ambient_volume"))
	if Server.world.name == "Overworld":
		stream = load("res://Assets/Sound/Sound effects/Ambience/spring_day.mp3")
		volume_db = Sounds.return_adjusted_sound_db("ambient", -22)
		play()
	else:
		stream = load("res://Assets/Sound/Sound effects/Ambience/cave ambience.mp3")
		volume_db = Sounds.return_adjusted_sound_db("ambient", -20)
		play()

func set_new_ambient_volume():
	if Server.world.name == "Overworld":
		if stream == load("res://Assets/Sound/Sound effects/Ambience/winter_day.mp3"):
			volume_db = Sounds.return_adjusted_sound_db("ambient", 0)
		else:
			volume_db = Sounds.return_adjusted_sound_db("ambient", -22)
	else:
		volume_db = Sounds.return_adjusted_sound_db("ambient", -20)

func _physics_process(delta):
	return
	if Server.player_node and Server.world.name == "Overworld":
		storm1 = get_node("/root/Overworld/RoamingStorm")
		storm2 = get_node("/root/Overworld/RoamingStorm2")
		if Server.player_node.position.distance_to(storm1.position) <= 2000:
			inside_storm(storm1)
		elif Server.player_node.position.distance_to(storm2.position) <= 2000:
			inside_storm(storm2)
		else:
			outside_storm()

func inside_storm(storm):
	if not is_inside_storm:
		if storm.is_snow_storm:
			stream = load("res://Assets/Sound/Sound effects/Ambience/winter_day.mp3")
			volume_db = Sounds.return_adjusted_sound_db("ambient", -12)
		else:
			stream = load("res://Assets/Sound/Sound effects/Ambience/rain.mp3")
			volume_db = Sounds.return_adjusted_sound_db("ambient", -22)
		is_inside_storm = true
		play()

func outside_storm():
	if is_inside_storm:
		is_inside_storm = false
		stream = load("res://Assets/Sound/Sound effects/Ambience/spring_day.mp3")
		play()
