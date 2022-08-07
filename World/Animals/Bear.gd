extends StaticBody2D

const SPEED: int = 160
var velocity: Vector2 = Vector2.ZERO

var path: Array = []
var worldNavigation: Navigation2D = null
var player = null
var direction = "down"
var player_spotted: bool = false
var playing_sound_effect: bool = false
var swinging = false
onready var los = $LineOfSight

var rng = RandomNumberGenerator.new()


func _ready():
	wait_for_map()

func wait_for_map():
	if Server.isLoaded:
		if Server.world.has_node("WorldNavigation"):
			print('set world nav')
			worldNavigation = get_node("/root/World/WorldNavigation")
		if Server.world.has_node("Players/" + Server.player_id):
			print('set player')
			player = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id)
	else:
		yield(get_tree().create_timer(2.5), "timeout")
		wait_for_map()
		
func _physics_process(delta):
	set_direction()
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			start_sound_effects()
			navigate(delta)
		else:
			stop_sound_effects()
			idle()
	
	
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
	var collider = los.get_collider()
	if global_position.distance_to(player.global_position) >= 500:
		player_spotted = false
	if collider and collider == player:
		$AnimationPlayer.play("loop")
		player_spotted = true
		return true
	return false

func navigate(delta):
	if path.size() > 0:
		set_direction()	
		$Bear.texture = load("res://Assets/Images/Animals/Bear/gallop/body/" + direction  + ".png")
		$Fangs.texture = load("res://Assets/Images/Animals/Bear/gallop/fangs/" + direction  + ".png")
		position = position.move_toward(path[0], delta * SPEED)
		if global_position == path[0]:
			path.pop_front()
	
	
#func set_direction(new_pos):
#	pass
#	var tempPos = position - new_pos
#	if tempPos.x > 0:
#		$AnimatedSprite.flip_h = true
#	else:
#		$AnimatedSprite.flip_h = false
	
func generate_path():
	if worldNavigation != null and player != null:
		path = worldNavigation.get_simple_path(global_position, player.global_position, false)


func idle():
	$Bear.texture = load("res://Assets/Images/Animals/Bear/idle/body/" + direction  + ".png")
	$Fangs.texture = load("res://Assets/Images/Animals/Bear/idle/fangs/" + direction  + ".png")

#func move():
#	if not swinging:
#		if worldNavigation != null and player != null:
#			velocity = move_and_slide(velocity)
#			if position.distance_to(player.position) > 50:
#				$Bear.texture = load("res://Assets/Images/Animals/Bear/walk/body/" + direction  + ".png")
#				$Fangs.texture = load("res://Assets/Images/Animals/Bear/walk/fangs/" + direction  + ".png")
#			else:
#				swing(direction)
	

	

func swing(direction):
	print("swing")
	pass
#	if not swinging:
#		play_groan_sound_effect()
#		swinging = true
#		if direction == "left":
#			$AnimationPlayer.play("swing left")
#			$AnimatedSprite.flip_h = true
#			$AnimatedSprite.play("swing side")
#		elif direction == "right":	
#			$AnimationPlayer.play("swing right")
#			$AnimatedSprite.flip_h = false
#			$AnimatedSprite.play("swing side")
#		else:
#			$AnimationPlayer.play("swing "+ direction)
#			$AnimatedSprite.play("swing " + direction)
#		yield($AnimatedSprite, "animation_finished")
#		swinging = false



func _on_Timer_timeout():
	if player:
		generate_path()
		#navigate()
