extends StaticBody2D

const GALLUP_SPEED: int = 180
const IDLE_SPEED: int = 120
var is_in_sight: bool = false
var changing_direction: bool = false
var path: Array = []
var player = null
var direction = "down"
var random_idle_pos = null
var player_spotted: bool = false
var playing_sound_effect: bool = false
var in_idle_state: bool = false
var swinging: bool = false
var current_pos = null
onready var los = $LineOfSight
onready var worldNavigation = get_node("/root/World/WorldNavigation")

var rng = RandomNumberGenerator.new()
var state = IDLE


enum {
	CHASE,
	SWING,
	IDLE,
	WALK
}


func _physics_process(delta):
	if is_in_sight:
		player = get_node("/root/World/Players/" + Server.player_id).get_children()[0]
		los.look_at(player.global_position)
		match state:
			CHASE:
				chase(delta)
			SWING:
				swing()
			IDLE:
				check_player_in_detection()
				idle()
			WALK:
				check_player_in_detection()
				navigate(delta)
	
	
func idle():
	$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/idle/body/" + direction  + ".png")
	$Body/Fangs.texture = null
	
	
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
		

func set_swing_direction():
	var degrees = int(los.rotation_degrees)
	if degrees > 0:
		degrees = degrees % 360
		if degrees < 45 or degrees > 315:
			direction = "right"
		elif degrees > 45 and degrees < 135:
			direction = "down"
		elif degrees > 135 and degrees < 225:
			direction = "left"
		else:
			direction = "up"
	else:
		degrees = -degrees % 360
		if degrees < 45 or degrees > 315:
			direction = "right"
		elif degrees > 45 and degrees < 135:
			direction = "up"
		elif degrees > 135 and degrees < 225:
			direction = "left"
		else:
			direction = "down"


func check_player_in_detection():
	var collider = los.get_collider()
	if collider and collider == player and not player.is_player_dead:
		if worldNavigation.get_simple_path(global_position, player.global_position, true).size() > 1:
			state = CHASE


func navigate(delta):
	if path.size() > 0:
		set_direction(path[0])
		set_texture()
		$AnimationPlayer.play("loop")
		if state == CHASE:
			position = position.move_toward(path[0], delta * GALLUP_SPEED)
		else:
			position = position.move_toward(path[0], delta * IDLE_SPEED)
		if global_position == path[0]:
			path.pop_front()
	else:
		if state == WALK:
			state = IDLE
		elif state == CHASE and position.distance_to(player.position) > 350:
			state = IDLE


func set_texture():
	match state:
		CHASE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/gallop/body/" + direction  + ".png")
			$Body/Fangs.texture = load("res://Assets/Images/Animals/Bear/gallop/fangs/" + direction  + ".png")
		WALK:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/walk/body/" + direction  + ".png")
			$Body/Fangs.texture = null #load("res://Assets/Images/Animals/Bear/walk/fangs/" + direction  + ".png")


func set_direction(new_pos):
	if not changing_direction:
		var tempPos = position - new_pos
		if abs(tempPos.y) > abs(tempPos.x):
			if tempPos.y > 0:
				change_direction("up")
			else:
				change_direction("down")
		elif tempPos.x > 0:
			change_direction("left")
		elif tempPos.x < 0:
			change_direction("right")


func change_direction(new_direction):
	if new_direction != direction:
		changing_direction = true
		direction = new_direction
		yield(get_tree().create_timer(0.25), "timeout")
		changing_direction = false


func chase(delta):
	if (position + Vector2(0,-26)).distance_to(player.position) > 70:
		navigate(delta)
	else:
		state = SWING


func swing():
	if not player.is_player_dead and path.size() > 0:
		if not swinging:
			swinging = true
			yield(get_tree().create_timer(0.15), "timeout")
			play_groan_sound_effect()
			set_swing_direction()
			if (position + Vector2(0,-26)).distance_to(player.position) < 50:
				$AnimationPlayer.play("bite " + direction)
			else:
				$AnimationPlayer.play("swing " + direction)
			yield($AnimationPlayer, "animation_finished")
			swinging = false
			path = worldNavigation.get_simple_path(global_position, player.global_position, true)
			state = CHASE
	else:
		state = IDLE


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	is_in_sight = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	is_in_sight = false


func _on_PathToPlayerTimer_timeout():
	if state == CHASE:
		path = worldNavigation.get_simple_path(global_position, player.global_position, true)
		if path.size() == 0:
			state = IDLE


func _on_RandomPathTimer_timeout():
	if state == IDLE:
		rng.randomize()
		random_idle_pos = Vector2(rng.randi_range(-300, 300), rng.randi_range(-300, 300))
		path = worldNavigation.get_simple_path(position, position + random_idle_pos, true)
		state = WALK


func _on_HurtBox_area_entered(area):
	$HurtBox/AnimationPlayer.play("hit")



func _on_CheckPositionTimer_timeout():
	if current_pos == position:
		rng.randomize()
		random_idle_pos = Vector2(rng.randi_range(-300, 300), rng.randi_range(-300, 300))
		path = worldNavigation.get_simple_path(position, position + random_idle_pos, true)
	else:
		current_pos = position
