extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	$Hitbox.tool_name = "lightning strike"
	$Hitbox.special_ability = "stun"
	play()


func play():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$AnimationPlayer.play("play")
	$AnimatedSprite.frame = 0
	$AnimatedSprite.playing = true
	yield(get_tree().create_timer(0.3), "timeout")
	$ExplosionParticles.emitting = true
	$ExplosionParticles2.emitting = true
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.hide()
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
