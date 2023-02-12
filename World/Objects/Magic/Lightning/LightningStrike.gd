extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	$Hitbox.tool_name = "lightning strike"
	$Hitbox.special_ability = "stun"
	play()


func play():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$AnimationPlayer.play("play")
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.playing = true
	await get_tree().create_timer(0.3).timeout
	$ExplosionParticles.emitting = true
	$ExplosionParticles2.emitting = true
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.hide()
	await get_tree().create_timer(2.0).timeout
	queue_free()
