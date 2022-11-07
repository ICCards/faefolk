extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var _idle_timer: Timer = $IdleTimer
onready var _chase_timer: Timer = $ChaseTimer
onready var _end_chase_state_timer: Timer = $EndChaseState
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var enemy_name = "bear"

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var stunned: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var changed_direction_delay: bool = false
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
	WALK,
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
	if not visible or destroyed:
		if state == CHASE:
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
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and not player.state == 5 and not player.get_node("Magic").invisibility_active:
		if state != CHASE and state != ATTACK:
			start_chase_state()
	if state == CHASE and (player.state == 5 or player.get_node("Magic").invisibility_active):
		end_chase_state()
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
	if tornado_node or stunned or attacking or destroyed:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	else:
		_velocity = move_and_slide(velocity)

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


func play_groan_sound_effect():
	rng.randomize()
	sound_effects.stream = Sounds.bear_grown[rng.randi_range(0, 2)]
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	sound_effects.play()
	yield(sound_effects, "finished")
	playing_sound_effect = false
	start_sound_effects()


func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Bear/bear pacing.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()


func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.stop()


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
	health -= Stats.return_tool_damage(tool_name)
	if health <= 0 and not destroyed:
		destroyed = true
		stop_sound_effects()
		$Body/Fangs.texture = null
		$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/death/" + direction  + "/body.png")
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		animation_player.play("death")
		yield(animation_player, "animation_finished")
		queue_free()


func _on_HurtBox_area_entered(area):
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != Vector2.ZERO:
		set_change_direction_delay()
		knockback = area.knockback_vector * 100
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		tornado_node = area


func start_stunned_state():
	if not destroyed:
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,6)
		$Electricity.show()
		$Position2D/BearBite/CollisionShape2D.set_deferred("disabled", true)
		$Position2D/BearClaw/CollisionShape2D.set_deferred("disabled", true)
		animation_player.stop(false)
		$StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		$Electricity.hide()
		stunned = false
		animation_player.play()

func _on_EndChaseState_timeout():
	end_chase_state()

func start_frozen_state(timer_length):
	$Body.modulate = Color("00c9ff")
	frozen = true
	$FrozenTimer.stop()
	$FrozenTimer.start(timer_length)
	if not attacking and not destroyed:
		animation_player.play("loop frozen")

func end_chase_state():
	navigation_agent.max_speed = 100
	stop_sound_effects()
	_idle_timer.start()
	_chase_timer.stop()
	_end_chase_state_timer.stop()
	state = IDLE

func start_chase_state():
	state = CHASE
	$Body/Fangs.show()
	navigation_agent.max_speed = 240
	start_sound_effects()
	_idle_timer.stop()
	_chase_timer.start()
	_end_chase_state_timer.start()


func _on_FrozenTimer_timeout():
	$Body.modulate = Color("ffffff")
	frozen = false
	if not destroyed:
		animation_player.play("loop")


func set_change_direction_delay():
	changed_direction_delay = true
	$ChangeDirectionDelay.start()

func _on_ChangeDirectionDelay_timeout():
	changed_direction_delay = false


func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()

