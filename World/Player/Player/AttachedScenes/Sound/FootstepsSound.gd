extends AudioStreamPlayer2D


func _ready():
	#volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
	Sounds.connect("footsteps_sound_change",Callable(self,"set_footsteps_sound"))
	Sounds.connect("volume_change",Callable(self,"set_new_music_volume"))
	PlayerData.connect("health_depleted",Callable(self,"reset_sound"))
	if Server.world.name == "main":
		pass
	else:
		Sounds.current_footsteps_sound = Sounds.stone_footsteps
	set_footsteps_sound()


func reset_sound():
	Sounds.current_footsteps_sound = Sounds.dirt_footsteps
	stream = Sounds.dirt_footsteps
	set_footsteps_sound()

func set_footsteps_sound():
	stream = Sounds.current_footsteps_sound
	set_new_music_volume()
	if Sounds.current_footsteps_sound == Sounds.dirt_footsteps:
		get_node("../../").is_walking_on_dirt = true
	else:
		get_node("../../").is_walking_on_dirt = false
	playing = true
	await get_tree().create_timer(0.1).timeout
	stream_paused = true


func set_new_music_volume():
	if Sounds.current_footsteps_sound == Sounds.stone_footsteps:
		volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
	else: 
		volume_db = Sounds.return_adjusted_sound_db("footstep", -10)


func _process(delta):
	if Server.player_node:
		if has_node("/root/Main"):
			var location = Tiles.ocean_tiles.local_to_map(Server.player_node.position)
			if Tiles.deep_ocean_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1):
				if Sounds.current_footsteps_sound != Sounds.swimming:
					Sounds.current_footsteps_sound = Sounds.swimming
					Sounds.emit_signal("footsteps_sound_change")
			elif Tiles.ocean_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1):
				if Sounds.current_footsteps_sound != null:
					play_water_step_sound()
					Sounds.current_footsteps_sound = null
					Sounds.emit_signal("footsteps_sound_change")
			elif Tiles.foundation_tiles.get_cell_atlas_coords(0,location) != Vector2i(-1,-1):
				if Sounds.current_footsteps_sound != Sounds.wood_footsteps:
					Sounds.current_footsteps_sound = Sounds.wood_footsteps
					Sounds.emit_signal("footsteps_sound_change")
#			elif Tiles.foundation_tiles.get_cellv(location) != -1:
#				if Sounds.current_footsteps_sound != Sounds.stone_footsteps:
#					Sounds.current_footsteps_sound = Sounds.stone_footsteps
#					Sounds.emit_signal("footsteps_sound_change")
			else:
				if Sounds.current_footsteps_sound != Sounds.dirt_footsteps:
					Sounds.current_footsteps_sound = Sounds.dirt_footsteps
					Sounds.emit_signal("footsteps_sound_change")
		else:
			var location = Tiles.ocean_tiles.local_to_map(Server.player_node.position)
			if Tiles.isCenterBitmaskTile(location,Tiles.ocean_tiles):
				if Sounds.current_footsteps_sound != Sounds.swimming:
					Sounds.current_footsteps_sound = Sounds.swimming
					Sounds.emit_signal("footsteps_sound_change")
			else:
				if Sounds.current_footsteps_sound != Sounds.stone_footsteps:
					Sounds.current_footsteps_sound = Sounds.stone_footsteps
					Sounds.emit_signal("footsteps_sound_change")


func play_water_step_sound():
	if Util.chance(33):
		stream = load("res://Assets/Sound/Sound effects/Footsteps/water/water_step1.mp3")
	elif Util.chance(33):
		stream = load("res://Assets/Sound/Sound effects/Footsteps/water/water_step2.mp3")
	else:
		stream = load("res://Assets/Sound/Sound effects/Footsteps/water/water_step3.mp3")
	play()
	await self.finished
	await get_tree().process_frame
	play_water_step_sound()
