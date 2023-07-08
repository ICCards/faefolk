extends Node


@export var night_hour = 18
@export var day_hour = 5

@onready var day_jingle: AudioStreamPlayer = $DayJingle
@onready var night_jingle: AudioStreamPlayer = $NightJingle
@onready var day_soundscape: AudioStreamPlayer = $DaySoundscape
@onready var night_soundscape: AudioStreamPlayer = $NightSoundscape

func _ready():
	PlayerData.connect("set_day",Callable(self,"set_day_sound"))
	PlayerData.connect("set_night",Callable(self,"set_night_sound"))
	Sounds.connect("volume_change",Callable(self,"set_new_ambient_volume"))
	set_new_ambient_volume()


func initialize():
	var hour = PlayerData.player_data["time_hours"]
	if hour <= 5 or hour >= 17:
		night_soundscape.play()
		day_soundscape.stop()
	else:
		day_soundscape.play()
		night_soundscape.stop()


func set_day_sound():
	day_jingle.play()
	day_soundscape.play()
	night_soundscape.stop()


func set_night_sound():
	night_jingle.play()
	day_soundscape.stop()
	night_soundscape.play()
	
	
func set_new_ambient_volume():
	day_jingle.volume_db = Sounds.return_adjusted_sound_db("ambient", -10)
	night_jingle.volume_db = Sounds.return_adjusted_sound_db("ambient", 0)
	day_soundscape.volume_db = Sounds.return_adjusted_sound_db("ambient", -10)
	night_soundscape.volume_db = Sounds.return_adjusted_sound_db("ambient", -10)
