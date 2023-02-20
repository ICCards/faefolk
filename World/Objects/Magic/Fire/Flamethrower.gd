extends Node2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var is_hostile: bool = false


func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "color", Color("ffffff"), 1.5)
	if is_hostile:
		$Hitbox.set_collision_mask(2+8+16+128+2048)
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -10)
	sound_effects.play()
	$Hitbox.tool_name = "flamethrower"
	$Fire.emitting = true
	$Smoke.emitting = true
	$AnimationPlayer.play("play")
	$Flamethrower.play("start")
	await $Flamethrower.animation_finished
	$Flamethrower.play("loop")
	await get_tree().create_timer(3.0).timeout
	$Flamethrower.play("start", true)
	fade_out_sound()
	$Fire.emitting = false
	$Smoke.emitting = false
	await $Flamethrower.animation_finished
	queue_free()

func fade_out_sound():
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "color", Color("00ffffff"), 1.5)
	tween.tween_property(sound_effects, "volume_db", -80, 1.5)
