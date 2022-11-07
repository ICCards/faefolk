extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$Hitbox.tool_name = "earth strike"
	$AnimationPlayer.play("play")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
