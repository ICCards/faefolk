extends KinematicBody2D

onready var hit_box: Area2D = $SlimeHit
onready var slime_sprite: AnimatedSprite = $SlimeSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var jumping: bool = false
var jump_delay: bool = false
var start_jump: bool = false
var knocking_back: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var jump_direction := Vector2.ZERO
var jump := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false
var health: int = Stats.SLIME_HEALTH

var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var state = IDLE

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

var JUMP_AMOUNT = 100
var KNOCKBACK_AMOUNT = 180
export var MAX_SPEED = 80
export var ACCELERATION = 200
export var FRICTION = 80

var poison_increment = 0
var amount_to_diminish = 0

var cancel_jump = false

enum {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	DEATH
}

func _ready():
	randomize()
	rng.randomize()
	hide()
	orbit_radius = 0 #rand_range(20, 40)
	slime_sprite.frame = rng.randi_range(0, 13)

	
func move(velocity: Vector2) -> void:
	if tornado_node or stunned or jumping or destroyed:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif poisoned:
		_velocity = move_and_slide(velocity*0.9)
	else:
		_velocity = move_and_slide(velocity)

func _physics_process(delta):
	if destroyed or not visible or stunned:
		return
	if tornado_node:
		orbit_radius += 1.0
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if knocking_back:
		velocity = velocity.move_toward(knockback * MAX_SPEED * 7, ACCELERATION * delta * 8)
		velocity = move_and_slide(velocity)
		return
	if jumping:
		velocity = velocity.move_toward(jump_direction * MAX_SPEED * 7, ACCELERATION * delta * 8)
		velocity = move_and_slide(velocity)
		return
	if not start_jump:
		var direction = (Server.player_node.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		move(velocity)
		slime_sprite.flip_h = velocity.x > 0
		if (position+Vector2(0,-9)).distance_to(Server.player_node.position) < 120 and not jump_delay:
			jump_forward()
		

func _on_KnockbackTimer_timeout():
	velocity = Vector2.ZERO
	knocking_back = false


func jump_forward():
	start_jump = true
	jump_delay = true
	$Timers/JumpDelay.start(rand_range(1.0, 2.5))
	slime_sprite.play("jump")
	yield(slime_sprite, "animation_finished")
	if not cancel_jump and not destroyed:
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/Slime/slime.wav")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
		sound_effects.play()
		slime_sprite.play("jumping")
		jumping = true
		jump_direction = (Server.player_node.global_position - global_position).normalized()
		yield(slime_sprite, "animation_finished")
		velocity = Vector2.ZERO
	cancel_jump = false
	jumping = false
	start_jump = false
	if not destroyed:
		slime_sprite.play("idle")


func _on_JumpDelay_timeout():
	jump_delay = false


func set_swing_direction():
	var degrees = int(hit_box.rotation_degrees) % 360
	if hit_box.rotation_degrees >= 0:
		if degrees <= 45 or degrees >= 315:
			direction = "right"
		elif degrees <= 135:
			direction = "down"
		elif degrees <= 225:
			direction = "left"
		else:
			direction = "up"
	else:
		if degrees >= -45 or degrees <= -315:
			direction = "right"
		elif degrees >= -135:
			direction = "up"
		elif degrees >= -225:
			direction = "left"
		else:
			direction = "down"


func hit(tool_name):
	if tool_name == "blizzard":
		start_frozen_state(8)
		return
	elif tool_name == "ice projectile":
		start_frozen_state(3)
	elif tool_name == "lightning spell debuff":
		start_stunned_state()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/Slime/slimeHit.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	destroyed = true
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		diminish_HOT(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.knockback_vector != Vector2.ZERO:
		if not destroyed:
			$KnockbackParticles.emitting = true
			knocking_back = true
			$Timers/KnockbackTimer.start()
			knockback = area.knockback_vector
			velocity = knockback * 200
			if start_jump:
				slime_sprite.play("idle")
				jumping = false
				start_jump = false
				cancel_jump = true
	if area.tool_name == "lingering tornado":
		orbit_radius = 0
		tornado_node = area
	if area.special_ability == "fire":
		InstancedScenes.initiateExplosionParticles(position)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	yield(get_tree().create_timer(0.25), "timeout")
	$KnockbackParticles.emitting = false

func diminish_HOT(type):
	start_poison_state()
	match type:
		"poison potion I":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.32
	poison_increment = int(ceil(amount_to_diminish / 4))
	if amount_to_diminish < poison_increment:
		health -= amount_to_diminish
		InstancedScenes.player_hit_effect(-amount_to_diminish, position)
		amount_to_diminish = 0
	else:
		health -= poison_increment
		InstancedScenes.player_hit_effect(-poison_increment, position)
		amount_to_diminish -= poison_increment
		$Timers/DiminishHOT.start(2)
		if health <= 0 and not destroyed:
			destroy()

func _on_DiminishHOT_timeout():
	if not destroyed:
		if amount_to_diminish < poison_increment:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, position)
			amount_to_diminish = 0
			$Timers/DiminishHOT.stop()
		else:
			health -= poison_increment
			InstancedScenes.player_hit_effect(-poison_increment, position)
			amount_to_diminish -= poison_increment
			$Timers/DiminishHOT.start(2)


func start_frozen_state(timer_length):
	slime_sprite.modulate = Color("00c9ff")
	frozen = true
	$Timers/FrozenTimer.start(timer_length)
	#if not attacking and not destroyed:
		#animation_player.play("loop frozen")

func _on_FrozenTimer_timeout():
	frozen = false
	if not poisoned:
		slime_sprite.modulate = Color("ffffff")

func start_poison_state():
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	slime_sprite.modulate = Color("009000")
	poisoned = true
	$Timers/PoisonTimer.start()

func _on_PoisonTimer_timeout():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	poisoned = false
	if not frozen:
		slime_sprite.modulate = Color("ffffff")

func start_stunned_state():
	if not destroyed:
		slime_sprite.playing = false
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,13)
		$Electricity.show()
		$Timers/StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		slime_sprite.playing = true
		$Electricity.hide()
		stunned = false

func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.stop()

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()


