extends AudioStreamPlayer

var is_inside_storm = false

func _ready():
	stream = Sounds.nature
	volume_db = Sounds.return_adjusted_sound_db("ambient", -16)
	play()
	Sounds.connect("volume_change", self, "set_new_music_volume")


func set_new_music_volume():
	volume_db = Sounds.return_adjusted_sound_db("ambient", -16)

func _process(delta):
	if Server.isLoaded:
		if get_parent().position.distance_to(get_node("/root/World/RoamingStorm").position) <= 2000:
			inside_storm()
		else:
			outside_storm()

func inside_storm():
	if not is_inside_storm:
		is_inside_storm = true
		stream = Sounds.rain
		play()

func outside_storm():
	if is_inside_storm:
		is_inside_storm = false
		stream = Sounds.nature
		play()
