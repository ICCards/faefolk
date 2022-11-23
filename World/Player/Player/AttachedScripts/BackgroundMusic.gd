extends AudioStreamPlayer

var rng = RandomNumberGenerator.new()
var index

func _ready():
	rng.randomize()
	Sounds.index = rng.randi_range(0,9)
	Sounds.connect("volume_change", self, "set_new_music_volume")
	Sounds.connect("song_skipped", self, "set_song")
	_play_background_music()

func set_song():
	stop()
	stream = load("res://Assets/Sound/Demos/" + Sounds.demo_names[Sounds.index] + ".mp3")
	play()

func _play_background_music():
	stream = load("res://Assets/Sound/Demos/" + Sounds.demo_names[Sounds.index] + ".mp3")
	volume_db =  Sounds.return_adjusted_sound_db("music", -32)
	play()
	yield(self, "finished")
	Sounds.index += 1
	if Sounds.index == 10:
		Sounds.index = 0
	Sounds.emit_signal("song_finished")
	_play_background_music()


func set_new_music_volume():
	volume_db = Sounds.return_adjusted_sound_db("music", -32)
