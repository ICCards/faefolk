extends KinematicBody2D

onready var hit_box: Area2D = $BoarBite
onready var boar_sprite: Sprite = $BoarSprite
onready var _idle_timer: Timer = $IdleTimer
onready var _chase_timer: Timer = $ChaseTimer
onready var _end_chase_state_timer: Timer = $EndChaseState
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var chasing: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 500.0
var changed_direction_delay: bool = false
var health: int = Stats.DEER_HEALTH
var KNOCKBACK_AMOUNT = 300
var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var state = IDLE

enum {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	DEATH
}
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	hide()
	orbit_radius = rand_range(30, 50)
	animation_player.play("loop")
	_idle_timer.wait_time = rand_range(4.0,6.0)
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	navigation_agent.connect("velocity_computed", self, "move") 
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.global_position)
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())
	
func set_sprite_texture():
	match state:
		IDLE:
			boar_sprite.texture = load("res://Assets/Images/Animals/Boar/idle/" +  direction + "/body.png")
		WALK:
			boar_sprite.texture = load("res://Assets/Images/Animals/Boar/walk/" +  direction + "/body.png")
		CHASE:
			boar_sprite.texture = load("res://Assets/Images/Animals/Boar/run/" +  direction + "/body.png")

func get_random_pos():
	random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	if Tiles.deep_ocean_tiles.get_cellv(Tiles.deep_ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.deep_ocean_tiles.get_cellv(Tiles.deep_ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position
	
func move(velocity: Vector2) -> void:
	if tornado_node or stunned or attacking or destroyed:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	else:
		_velocity = move_and_slide(velocity)

func _physics_process(delta):
	if not visible or destroyed:
		if chasing:
			end_chase_state()
		return
	if stunned or attacking:
		return
	if tornado_node:
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if knockback != Vector2.ZERO:
		_velocity = Vector2.ZERO
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_AMOUNT * delta)
		knockback = move_and_slide(knockback)
		return
	set_direction()
	set_sprite_texture()
	if navigation_agent.is_navigation_finished():
		state = IDLE
		return
	if player.state == 5 or player.get_node("Magic").invisibility_active:
		end_chase_state()
	if chasing:
		state = CHASE
	else:
		state = WALK
	if state == CHASE and (position+Vector2(0,-9)).distance_to(player.position) < 70:
		state = ATTACK
		attack()
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	navigation_agent.set_velocity(_velocity)
	
func attack():
	if not attacking:
		play_groan_sound_effect()
		attacking = true
		hit_box.look_at(player.position)
		set_swing_direction()
		boar_sprite.texture = load("res://Assets/Images/Animals/Boar/attack/" +  direction + "/body.png")
		animation_player.play("attack")
		yield(animation_player, "animation_finished")
		if not destroyed:
			if frozen:
				animation_player.play("loop frozen")
			else:
				animation_player.play("loop")
			attacking = false
			state = CHASE
	
func set_direction():
	if not changed_direction_delay:
		if abs(_velocity.x) >= abs(_velocity.y):
			if _velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_delay()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_delay()
		else:
			if _velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_delay()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_delay()

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
	if state == IDLE or state == WALK:
		start_chase_state()
	_end_chase_state_timer.stop()
	_end_chase_state_timer.start()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	destroyed = true
	boar_sprite.texture = load("res://Assets/Images/Animals/Boar/death/" +  direction + "/body.png")
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
	if area.knockback_vector != Vector2.ZERO and not attacking:
		set_change_direction_delay()
		knockback = area.knockback_vector * 100
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		tornado_node = area

func diminish_HOT(type):
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


func _on_DetectPlayer_area_entered(area):
	start_chase_state()

func start_chase_state():
	start_sound_effects()
	navigation_agent.max_speed = 250
	_idle_timer.stop()
	_chase_timer.start()
	_end_chase_state_timer.start()
	chasing = true
	state = CHASE

func end_chase_state():
	stop_sound_effects()
	navigation_agent.max_speed = 100
	_chase_timer.stop()
	_idle_timer.start()
	chasing = false
	state = IDLE

func _on_EndChaseState_timeout():
	end_chase_state()

func set_change_direction_delay():
	changed_direction_delay = true
	$ChangeDirectionDelay.start()

func _on_ChangeDirectionDelay_timeout():
	changed_direction_delay = false

func start_frozen_state(timer_length):
	boar_sprite.modulate = Color("00c9ff")
	frozen = true
	$FrozenTimer.stop()
	$FrozenTimer.start(timer_length)
	if not attacking and not destroyed:
		animation_player.play("loop frozen")

func _on_FrozenTimer_timeout():
	boar_sprite.modulate = Color("ffffff")
	frozen = false
	if not destroyed:
		animation_player.play("loop")

func start_stunned_state():
	if not destroyed:
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,13)
		$Electricity.show()
		$BoarBite/CollisionShape2D.set_deferred("disabled", true)
		animation_player.stop(false)
		$StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		$Electricity.hide()
		stunned = false
		animation_player.play()


func play_groan_sound_effect():
	rng.randomize()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/attack.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	sound_effects.play()
	yield(sound_effects, "finished")
	playing_sound_effect = false
	start_sound_effects()


func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/gallop.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()


func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.stop()

func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()


