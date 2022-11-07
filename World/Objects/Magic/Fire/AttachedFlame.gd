extends AnimatedSprite

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	frame = 0
	playing = true
	yield(self, "animation_finished")
	frame = 0
	playing = true
	yield(self, "animation_finished")
	frame = 0
	playing = true
	yield(self, "animation_finished")
	queue_free()
