extends AudioStreamPlayer

var is_inside_storm = false
onready var storm1 = get_node("/root/World/RoamingStorm")
onready var storm2 = get_node("/root/World/RoamingStorm2")


func _ready():
	stream = Sounds.nature
	volume_db = Sounds.return_adjusted_sound_db("ambient", -16)
	play()
	Sounds.connect("volume_change", self, "set_new_music_volume")


func set_new_music_volume():
	volume_db = Sounds.return_adjusted_sound_db("ambient", -16)

func _process(delta):
	if Server.isLoaded:
		if get_parent().position.distance_to(storm1.position) <= 2000:
			inside_storm(storm1)
		elif get_parent().position.distance_to(storm2.position) <= 2000:
			inside_storm(storm2)
		else:
			outside_storm()

func inside_storm(storm):
	if not is_inside_storm:
		if storm.is_snow_storm:
			stream = Sounds.blizzard
		else:
			stream = Sounds.rain
		is_inside_storm = true
		play()

func outside_storm():
	if is_inside_storm:
		is_inside_storm = false
		stream = Sounds.nature
		play()
