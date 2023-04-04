extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()
var current_song_index

func _ready():
	if not get_node("../../").is_multiplayer_authority(): queue_free()
	rng.randomize()
	Sounds.connect("volume_change",Callable(self,"set_new_music_volume"))
	_play_background_music()


func _play_background_music():
	current_song_index = rng.randi_range(0,2)
	stream = Sounds.background_songs[current_song_index]
	if current_song_index == 0:
		volume_db =  Sounds.return_adjusted_sound_db("music", -16)
	else:
		volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	play()
	await self.finished
	#Sounds.emit_signal("song_finished")
	_play_background_music()

func set_new_music_volume():
	if current_song_index == 0:
		volume_db =  Sounds.return_adjusted_sound_db("music", -16)
	else:
		volume_db =  Sounds.return_adjusted_sound_db("music", -32)
