extends KinematicBody2D

const SPEED: int = 130
var velocity: Vector2 = Vector2.ZERO

var path: Array = []
var worldNavigation: Navigation2D = null
var player = null
var direction = "down"
var player_spotted: bool = false
var playing_sound_effect: bool = false
var swinging = false
var random_idle_pos = null
onready var los = $LineOfSight

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$AnimatedSprite.frames = Images.returnRandomSnake()
	idle()
	wait_for_map()
	PlayerStats.connect("health_depleted", self, "player_death")
	
	
func player_death():
	random_idle_pos = null
	player_spotted = false

func wait_for_map():
	if Server.isLoaded:
		if Server.world.has_node("WorldNavigation"):
			worldNavigation = get_node("/root/World/WorldNavigation")
		if Server.world.has_node("Players/" + Server.player_id):
			player = get_node("/root/World/Players/" + Server.player_id)
	else:
		yield(get_tree().create_timer(2.5), "timeout")
		wait_for_map()
		
func _physics_process(delta):
	$Line2D.global_position = Vector2.ZERO
	set_direction()
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			random_idle_pos = null
			start_sound_effects()
			move()
		else:
			stop_sound_effects()
			idle()
	
	
func play_swing_sound_effect():
	rng.randomize()
	$AudioStreamPlayer2D.stream = preload("res://Assets/Sound/Sound effects/Animals/Snake/ES_Snake Hiss 2 - SFX Producer.mp3")
	$AudioStreamPlayer2D.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$AudioStreamPlayer2D.play()
	yield($AudioStreamPlayer2D, "finished")
	playing_sound_effect = false
	start_sound_effects()
	
	
func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		$AudioStreamPlayer2D.stream = preload("res://Assets/Sound/Sound effects/Animals/Snake/ES_Snake Slither - SFX Producer.mp3")
		$AudioStreamPlayer2D.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$AudioStreamPlayer2D.play()
		
func stop_sound_effects():
	playing_sound_effect = false
	$AudioStreamPlayer2D.stop()
		

func set_direction():
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

func check_player_in_detection() -> bool:
	if not player.is_player_dead:
		var collider = los.get_collider()
		if global_position.distance_to(player.global_position) >= 500:
			player_spotted = false
		if collider and collider == player:
			player_spotted = true
			return true
		return false
	return false

func navigate():
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * SPEED
		if global_position == path[0]:
			path.pop_front()
	
func generate_path():
	if worldNavigation != null and player != null:
		path = worldNavigation.get_simple_path(global_position, player.global_position, false)
		$Line2D.points = path

func idle():
	if random_idle_pos == null:
		rng.randomize()
		random_idle_pos = global_position + Vector2(rng.randi_range(-100, 100), rng.randi_range(-100, 100))
		velocity = global_position.direction_to(random_idle_pos) * SPEED
	velocity = move_and_slide(velocity)
	if direction == "left":
		$AnimatedSprite.play("walk side")
		$AnimatedSprite.flip_h = true
	elif direction == "right":
		$AnimatedSprite.play("walk side")
		$AnimatedSprite.flip_h = false
	else: 
		$AnimatedSprite.play("walk " + direction)

func move():
	if not swinging:
		if worldNavigation != null and player != null:
			velocity = move_and_slide(velocity)
			if position.distance_to(player.position) > 30:
				if direction == "left":
					$AnimatedSprite.play("walk side")
					$AnimatedSprite.flip_h = true
				elif direction == "right":
					$AnimatedSprite.play("walk side")
					$AnimatedSprite.flip_h = false
				else:
					$AnimatedSprite.play("walk " + direction)
					$AnimatedSprite.flip_h = false
			else:
				swing(direction)

func swing(direction):
	if not swinging:
		velocity = move_and_slide(velocity)
		play_swing_sound_effect()
		swinging = true
		if direction == "left":
			$AnimationPlayer.play("swing left")
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("swing side")
		elif direction == "right":	
			$AnimationPlayer.play("swing right")
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("swing side")
		else:
			$AnimationPlayer.play("swing "+ direction)
			$AnimatedSprite.play("swing " + direction)
		yield($AnimatedSprite, "animation_finished")
		swinging = false


func _on_Timer_timeout():
	if player and player_spotted:
		generate_path()
		navigate()
	else:
		random_idle_pos = global_position + Vector2(rng.randi_range(-100, 100), rng.randi_range(-100, 100))
		velocity = global_position.direction_to(random_idle_pos) * SPEED
