extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if Sounds.background_song_index == null:
		Sounds.background_song_index = rng.randi_range(0,Sounds.background_songs.size()-1)
	else:
		Sounds.background_song_index += 1
		if Sounds.background_song_index == Sounds.background_songs.size():
			Sounds.background_song_index = 0
	Sounds.connect("volume_change",Callable(self,"set_new_music_volume"))
	_play_background_music()


func _play_background_music():
	print("BG MUSIC INDEX " + str(Sounds.background_song_index))
	stream = Sounds.background_songs[Sounds.background_song_index]
	if Sounds.background_song_index == 0 or Sounds.background_song_index == 1:
		volume_db =  Sounds.return_adjusted_sound_db("music", -16)
	else:
		volume_db =  Sounds.return_adjusted_sound_db("music", -24)
	play()
	await self.finished
	Sounds.background_song_index += 1
	if Sounds.background_song_index == Sounds.background_songs.size():
		Sounds.background_song_index = 0
	_play_background_music()

func set_new_music_volume():
	if Sounds.background_song_index == 0 or Sounds.background_song_index == 1:
		volume_db =  Sounds.return_adjusted_sound_db("music", -16)
	else:
		volume_db =  Sounds.return_adjusted_sound_db("music", -24)
