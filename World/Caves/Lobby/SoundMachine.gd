extends Node


func _ready():
	$CaveAmbience.volume_db = Sounds.return_adjusted_sound_db("ambient", -8)
	Sounds.connect("volume_change",Callable(self,"set_new_ambient_volume"))
	

func set_new_ambient_volume():
	$CaveAmbience.volume_db = Sounds.return_adjusted_sound_db("ambient", -8)
