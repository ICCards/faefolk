extends Line2D

onready var sound_effects: AudioStreamPlayer = $SoundEffects

func _ready():
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
