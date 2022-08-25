extends AudioStreamPlayer


func _ready():
	Sounds.connect("footsteps_sound_change", self, "set_footsteps_sound")
	Sounds.connect("volume_change", self, "set_new_music_volume")
	
	
func set_footsteps_sound():
	stream = Sounds.current_footsteps_sound
	set_new_music_volume()
	play()
	if Sounds.current_footsteps_sound == Sounds.dirt_footsteps:
		get_node("../../").is_walking_on_dirt = true
	else:
		get_node("../../").is_walking_on_dirt = false


func set_new_music_volume():
	if Sounds.current_footsteps_sound == Sounds.stone_footsteps:
		volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
	else: 
		volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
