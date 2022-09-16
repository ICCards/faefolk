extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()

func _ready():
	Sounds.connect("volume_change", self, "set_new_music_volume")
	_play_background_music()

func _play_background_music():
	rng.randomize()
	stream = Sounds.background_music[rng.randi_range(0, Sounds.background_music.size() - 1)]
	volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	play()
	yield(self, "finished")
	_play_background_music()


func set_new_music_volume():
	volume_db = Sounds.return_adjusted_sound_db("music", -32)
