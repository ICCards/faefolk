extends AnimatedSprite

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	show()
	animation = "start"
	play()
	yield(self, "animation_finished")
	animation = "idle"
	play()
	yield(self, "animation_finished")
	animation = "end"
	play()
	yield(self, "animation_finished")
	get_parent().emit_signal("spell_finished")
	queue_free()


func destroy():
	stop()
	queue_free()
