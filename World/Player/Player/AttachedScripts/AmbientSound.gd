extends AudioStreamPlayer

var is_inside_storm = false
var storm1
var storm2


func _ready():
	stream = Sounds.nature
	volume_db = Sounds.return_adjusted_sound_db("ambient", -20)
	play()
	Sounds.connect("volume_change", self, "set_new_music_volume")


func set_new_music_volume():
	volume_db = Sounds.return_adjusted_sound_db("ambient", -20)

func _process(delta):
	if Server.isLoaded and has_node("/root/World"):
		storm1 = get_node("/root/World/RoamingStorm")
		#storm2 = get_node("/root/World/RoamingStorm2")
		if Server.player_node.position.distance_to(storm1.position) <= 2000:
			inside_storm(storm1)
#		elif get_parent().position.distance_to(storm2.position) <= 2000:
#			inside_storm(storm2)
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
