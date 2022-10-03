extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D
onready var _idle_timer: Timer = $IdleTimer
onready var _chase_timer: Timer = $ChaseTimer

const GALLUP_SPEED: int = 180
const IDLE_SPEED: int = 120
var is_in_sight: bool = false
var player = Server.player_node
var direction = "down"
var random_pos = null
var player_spotted: bool = false
var is_dead: bool = false
var playing_sound_effect: bool = false
var swinging: bool = false
var current_pos = null
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO

var rng = RandomNumberGenerator.new()
var state = IDLE
var health: int = Stats.BEAR_HEALTH
var KNOCKBACK_AMOUNT = 400

enum {
	CHASE,
	SWING,
	IDLE,
	WALK
}

func _ready():
	animation_player.play("loop")
	randomize()
	_idle_timer.wait_time = rand_range(4.0, 6.0)
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	navigation_agent.connect("velocity_computed", self, "move")


func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_location(get_random_pos())

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.global_position)


func get_random_pos():
	random_pos = Vector2(rand_range(-300, 300), rand_range(-300, 300))
	if Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position


func _physics_process(delta):
	if not visible and not is_dead:
		return
	match state:
		CHASE:
			chase()
		SWING:
			swing()
		IDLE:
			idle()
		WALK:
			walk()
	set_direction()
	set_texture()
	if knockback != Vector2.ZERO:
		velocity = Vector2.ZERO
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_AMOUNT * delta)
		knockback = move_and_slide(knockback)
	if navigation_agent.is_navigation_finished() and state == WALK or state == IDLE:
		state = IDLE
		return
	if state == CHASE and (position + Vector2(0,-26)).distance_to(player.position) < 70:
		state = SWING
		swing()
		
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 0.5
	velocity += steering
	navigation_agent.set_velocity(velocity)
	
func idle():
	pass
	
func walk():
	pass
	
	
func move(velocity: Vector2) -> void:
	if not swinging:
		if state == IDLE:
			velocity = move_and_slide(velocity)
		else:
			velocity = move_and_slide(velocity*2.5)

func set_direction():
	if abs(velocity.x) >= abs(velocity.y):
		if velocity.x >= 0:
			direction = "right"
		else:
			direction = "left"
	else:
		if velocity.y >= 0:
			direction = "down"
		else:
			direction = "up"

func chase():
	pass


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
			$Body/Fangs.texture = null #load("res://Assets/Images/Animals/Bear/walk/fangs/" + direction  + ".png")
		IDLE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/idle/body/" + direction  + ".png")
			$Body/Fangs.texture = null



func swing():
	if not player.state == 5: # player dead
		if not swinging:
			swinging = true
			yield(get_tree().create_timer(0.15), "timeout")
			play_groan_sound_effect()
			#set_swing_direction()
			if (position + Vector2(0,-26)).distance_to(player.position) < 45:
				$AnimationPlayer.play("bite " + direction)
			else:
				$AnimationPlayer.play("swing " + direction)
			yield($AnimationPlayer, "animation_finished")
			swinging = false
			animation_player.play("loop")
			state = CHASE
	else:
		state = IDLE



func _on_HurtBox_area_entered(area):
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 100
	$HurtBox/AnimationPlayer.play("hit")
	deduct_health(area.tool_name)
	if health <= 0 and not is_dead:
		is_dead = true
		yield(get_tree().create_timer(2.0), "timeout")
		queue_free()

func deduct_health(tool_name):
	match tool_name:
		"wood sword":
			health -= Stats.WOOD_SWORD_DAMAGE
		"stone sword":
			health -= Stats.STONE_SWORD_DAMAGE
		"bronze sword":
			health -= Stats.BRONZE_SWORD_DAMAGE
		"iron sword":
			health -= Stats.IRON_SWORD_DAMAGE
		"gold sword":
			health -= Stats.GOLD_SWORD_DAMAGE
		"arrow":
			health -= Stats.ARROW_DAMAGE

func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false

func _on_DetectPlayer_area_entered(area):
	_idle_timer.stop()
	_chase_timer.start()
	state = CHASE

