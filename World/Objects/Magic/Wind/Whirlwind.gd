extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var is_hostile: bool = false

var player_id

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "color", Color("ffffff"), 1.0)
#	if is_hostile:
#		z_index = -1
#		$Hitbox.set_collision_mask(128+2048+8+16)
#		$AnimationPlayer.play("enemy")
#	else:
	if player_id == Server.player_node.name:
		$Hitbox.tool_name = "whirlwind spell"
		$Hitbox.set_collision_layer(2048+262144)
	$AnimationPlayer.play("player")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 16)
	sound_effects.play()
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 1.0)
	tween.tween_property(sound_effects, "volume_db", -80, 1.0)
	tween.tween_property($PointLight2D, "color", Color("00ffffff"), 1.0)


