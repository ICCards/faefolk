extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var _idle_timer: Timer = $IdleTimer
onready var _chase_timer: Timer = $ChaseTimer
onready var _end_chase_state_timer: Timer = $EndChaseState

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var changed_direction: bool = false
var frozen: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var d := 0.0
var orbit_speed := 5.0
var orbit_radius

var rng = RandomNumberGenerator.new()
var state = IDLE
var health: int = Stats.BEAR_HEALTH
var KNOCKBACK_AMOUNT = 300
var MAX_MOVE_DISTANCE: float = 400.0

var tornado_node = null

enum {
	CHASE,
	ATTACK,
	IDLE,
	WALK
}

func _ready():
	hide()
	animation_player.play("loop")
	randomize()
	orbit_radius = rand_range(40, 60)
	_idle_timer.wait_time = rand_range(4.0, 6.0)
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_end_chase_state_timer.connect("timeout", self, "end_chase_state")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))


func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_location(get_random_pos())

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.position)


func get_random_pos():
	random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	if Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position

func _physics_process(delta):
	if tornado_node:
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if not visible or destroyed:
		return
	set_direction()
	set_texture()
	if knockback != Vector2.ZERO:
		_velocity = Vector2.ZERO
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_AMOUNT * delta)
		knockback = move_and_slide(knockback)
	if navigation_agent.is_navigation_finished() and (state == WALK or state == IDLE):
		state = IDLE
		return
	if state == CHASE and (position + Vector2(0,-26)).distance_to(player.position) < 75:
		state = ATTACK
		swing()
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	navigation_agent.set_velocity(_velocity)

func move(velocity: Vector2) -> void:
	if tornado_node:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif not attacking and not destroyed:
		_velocity = move_and_slide(velocity)

func set_direction():
	if not changed_direction:
		if abs(_velocity.x) >= abs(_velocity.y):
			if _velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_wait()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_wait()
		else:
			if _velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_wait()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_wait()

func set_change_direction_wait():
	changed_direction = true
	yield(get_tree().create_timer(0.5), "timeout")
	changed_direction = false


func play_groan_sound_effect():
	rng.randomize()
	$AudioStreamPlayer2D.stream = Sounds.bear_grown[rng.randi_range(0, 2)]
	$AudioStreamPlayer2D.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$AudioStreamPlayer2D.play()
	yield($AudioStreamPlayer2D, "finished")
	playing_sound_effect = false
	start_sound_effects()


func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		$AudioStreamPlayer2D.stream = preload("res://Assets/Sound/Sound effects/Animals/Bear/bear pacing.mp3")
		$AudioStreamPlayer2D.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		$AudioStreamPlayer2D.play()


func stop_sound_effects():
	playing_sound_effect = false
	$AudioStreamPlayer2D.stop()


func set_texture():
	match state:
		CHASE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/gallop/body/" + direction  + ".png")
			$Body/Fangs.texture = load("res://Assets/Images/Animals/Bear/gallop/fangs/" + direction  + ".png")
		WALK:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/walk/body/" + direction  + ".png")
			$Body/Fangs.texture = null 
		IDLE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/idle/body/" + direction  + ".png")
			$Body/Fangs.texture = null


func swing():
	if not player.state == 5: # player dead
		if not attacking:
			attacking = true
			yield(get_tree().create_timer(0.1), "timeout")
			play_groan_sound_effect()
			if (position + Vector2(0,-26)).distance_to(player.position) < 45:
				animation_player.play("bite " + direction)
			else:
				if Util.chance(25):
					animation_player.play("bite " + direction)
				else:
					animation_player.play("swing " + direction)
			yield(animation_player, "animation_finished")
			if not destroyed:
				if frozen:
					animation_player.play("loop frozen")
				else:
					animation_player.play("loop")
				attacking = false
				state = CHASE
	else:
		end_chase_state()


func hit(tool_name):
	if state == IDLE or state == WALK:
		start_chase_state()
	_end_chase_state_timer.stop()
	_end_chase_state_timer.start()
	$HurtBox/AnimationPlayer.play("hit")
	health -= Stats.return_sword_damage(tool_name)
	if health <= 0 and not destroyed:
		destroyed = true
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		animation_player.play("death")
		yield(animation_player, "animation_finished")
		queue_free()


func _on_HurtBox_area_entered(area):
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 100
	if area.tool_name != "lightning spell" and area.tool_name != "explosion spell":
		hit(area.tool_name)
	if area.tool_name == "ice projectile":
		start_frozen_state()
	if area.tool_name == "lingering tornado":
		tornado_node = area


func start_frozen_state():
	$Body.modulate = Color("00c9ff")
	frozen = true
	$FrozenTimer.stop()
	$FrozenTimer.start()
	if not attacking and not destroyed:
		animation_player.play("loop frozen")


func _on_DetectPlayer_area_entered(area):
	start_chase_state()

func end_chase_state():
	print("END CHASE STATE")
	navigation_agent.max_speed = 100
	stop_sound_effects()
	_idle_timer.start()
	_chase_timer.stop()
	_end_chase_state_timer.stop()
	state = IDLE

func start_chase_state():
	navigation_agent.max_speed = 240
	start_sound_effects()
	_idle_timer.stop()
	_chase_timer.start()
	_end_chase_state_timer.start()
	state = CHASE


func _on_FrozenTimer_timeout():
	$Body.modulate = Color("ffffff")
	frozen = false
	animation_player.play("loop")


func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()
