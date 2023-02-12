extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

func _ready():
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -32)
	sound_effects.play()
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")

func _on_Area2D_area_entered(area):
	Server.player_node.actions.teleport(position)

