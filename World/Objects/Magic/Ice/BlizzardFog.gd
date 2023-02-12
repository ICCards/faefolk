extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var tween = get_tree().create_tween()

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	$Hitbox.tool_name = "blizzard"
	$AnimationPlayer.play("play")


func fade_out_sound():
	tween.tween_property(sound_effects, "volume_db", -80, 1.0)

func _on_Timer_timeout():
	queue_free()

func destroy():
	queue_free()
