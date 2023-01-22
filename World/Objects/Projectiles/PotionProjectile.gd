extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var speed = 500
var destroyed: bool = false
var target
var particles_transform
var potion_name

func _physics_process(delta):
	position = position.move_toward(target, delta * speed)
	if position == target:
		if not destroyed:
			destroy()
		return

func _ready():
	$Sprite.texture = load("res://Assets/Images/inventory_icons/Potion/"+ potion_name  +".png")
	$PotionHitbox.tool_name = potion_name
	if potion_name == "destruction potion I" or potion_name == "destruction potion II" or potion_name == "destruction potion III":
		$PotionHitbox.set_collision_mask(264320)
		$DestructionTrailParticles.show()
		$DestructionTrailParticles.transform = particles_transform
		$DestructionTrailParticles.position += Vector2(0,32)
	elif potion_name == "poison potion I" or potion_name == "poison potion II" or potion_name == "poison potion III":
		$PotionHitbox.set_collision_mask(384)
		$PoisonTrailParticles.show()
		$PoisonTrailParticles.transform = particles_transform
		$PoisonTrailParticles.position += Vector2(0,32)
	elif potion_name == "speed potion I" or potion_name == "speed potion II" or potion_name == "speed potion III":
		$SpeedTrailParticles.show()
		$SpeedTrailParticles.transform = particles_transform
		$SpeedTrailParticles.position += Vector2(0,32)
	else:
		$HealthTrailParticles.show()
		$HealthTrailParticles.transform = particles_transform
		$HealthTrailParticles.position += Vector2(0,32)
	yield(get_tree().create_timer(0.025), "timeout")
	if not destroyed:
		$Sprite.show()

func destroy():
	destroyed = true
	$Sprite.call_deferred("hide")
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Magic/Potion/glass break.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -14))
	sound_effects.call_deferred("play")
	if potion_name == "destruction potion I" or potion_name == "destruction potion II" or potion_name == "destruction potion III":
		$AnimationPlayer.call_deferred("play", "destruction potion")
	elif potion_name == "poison potion I" or potion_name == "poison potion II" or potion_name == "poison potion III":
		$AnimationPlayer.call_deferred("play", "poison potion")
	elif potion_name == "speed potion I" or potion_name == "speed potion II" or potion_name == "speed potion III":
		$AnimationPlayer.call_deferred("play", "speed potion")
	else:
		$AnimationPlayer.call_deferred("play", "health potion")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
