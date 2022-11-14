extends KinematicBody2D

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var jumping: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var knockback_vector := Vector2.ZERO
var jump := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false

var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var bat_sprite: AnimatedSprite = $BatSprite
var health: int = Stats.BAT_HEALTH
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

export var MAX_SPEED = 160
export var ACCELERATION = 180
export var FRICTION = 80
export var KNOCKBACK_AMOUNT = 70


func _ready():
	randomize()
	rng.randomize()
	orbit_radius = rand_range(20, 40)

func _physics_process(delta):
	if tornado_node:
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if not destroyed:
		$BatHit.look_at(Server.player_node.position)
		set_direction()
		bat_sprite.play("fly " + direction)
		var direction = (Server.player_node.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		move(velocity)


func move(velocity: Vector2) -> void:
	if tornado_node or stunned or jumping or destroyed:
		return
	if frozen:
		velocity = move_and_slide(velocity*0.75)
	elif poisoned:
		velocity = move_and_slide(velocity*0.9)
	else:
		velocity = move_and_slide(velocity)


func set_direction():
	var degrees = int($BatHit.rotation_degrees) % 360
	if $BatHit.rotation_degrees >= 0:
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



func _on_HurtBox_area_entered(area):
	if not destroyed:
		if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
			$HurtBox/AnimationPlayer.play("hit")
			diminish_HOT(area.tool_name)
			return
		if area.name == "SwordSwing":
			Stats.decrease_tool_health()
		if area.knockback_vector != Vector2.ZERO:
			knockback_vector = area.knockback_vector
			velocity = knockback_vector * 200
		if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
			hit(area.tool_name)
		if area.tool_name == "lingering tornado":
			tornado_node = area
		if area.special_ability == "fire":
			InstancedScenes.initiateExplosionParticles(position)
			InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position)
			health -= Stats.FIRE_DEBUFF_DAMAGE
		
		
func hit(tool_name):
	if tool_name == "blizzard":
		start_frozen_state(8)
		return
	elif tool_name == "ice projectile":
		start_frozen_state(3)
	elif tool_name == "lightning spell debuff":
		start_stunned_state()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	destroyed = true
	bat_sprite.play("death " + direction)
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	queue_free()


func diminish_HOT(type):
	start_poison_state()
	var amount_to_diminish
	match type:
		"poison potion I":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.32
	var increment = int(ceil(amount_to_diminish / 4))
	while int(amount_to_diminish) > 0 and not destroyed:
		if amount_to_diminish < increment:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, position)
			amount_to_diminish = 0
		else:
			health -= increment
			InstancedScenes.player_hit_effect(-increment, position)
			amount_to_diminish -= increment
		if health <= 0 and not destroyed:
			destroy()
		yield(get_tree().create_timer(2.0), "timeout")


func start_frozen_state(timer_length):
	bat_sprite.modulate = Color("00c9ff")
	frozen = true
	$Timers/FrozenTimer.start(timer_length)
	#if not attacking and not destroyed:
		#animation_player.play("loop frozen")

func _on_FrozenTimer_timeout():
	frozen = false
	if not poisoned:
		bat_sprite.modulate = Color("ffffff")
		#if not destroyed:
			#animation_player.play("loop")

func start_poison_state():
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	bat_sprite.modulate = Color("009000")
	poisoned = true
	$Timers/PoisonTimer.start()
	#if not attacking and not destroyed:
		#animation_player.play("loop frozen")

func _on_PoisonTimer_timeout():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	poisoned = false
	if not frozen:
		bat_sprite.modulate = Color("ffffff")
		#if not destroyed:
			#animation_player.play("loop")

func start_stunned_state():
	if not destroyed:
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,13)
		$Electricity.show()
		$BoarBite/CollisionShape2D.set_deferred("disabled", true)
		#animation_player.stop(false)
		$Timers/StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		$Electricity.hide()
		stunned = false
		#animation_player.play()


func play_groan_sound_effect():
	rng.randomize()
	#sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/attack.mp3")
	#sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	#sound_effects.play()
	#yield(sound_effects, "finished")
	playing_sound_effect = false
	start_sound_effects()


func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		#sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/gallop.mp3")
		#sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		#sound_effects.play()


func stop_sound_effects():
	playing_sound_effect = false
	#sound_effects.stop()

func _on_VisibilityNotifier2D_screen_entered():
	pass
	show()

func _on_VisibilityNotifier2D_screen_exited():
	pass
	#hide()

