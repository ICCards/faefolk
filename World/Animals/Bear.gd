extends KinematicBody2D

const SPEED: int = 120
var velocity: Vector2 = Vector2.ZERO

var path: Array = []
var worldNavigation: Navigation2D = null
var player = null
var direction = "down"
var player_spotted: bool = false
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
			player = get_node("/root/World/Players/" + Server.player_id)
	else:
		yield(get_tree().create_timer(2.5), "timeout")
		wait_for_map()
		
func _physics_process(delta):
	set_direction()
	if player:
		los.look_at(player.global_position)
		check_player_in_detection()
		if player_spotted:
			move()
		else:
			idle()
	

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
		player_spotted = true
		return true
	return false

func navigate():
	if path.size() > 1:
		velocity = global_position.direction_to(path[1]) * SPEED
		if global_position == path[0]:
			path.pop_front()
	
func generate_path():
	if worldNavigation != null and player != null:
		path = worldNavigation.get_simple_path(global_position, player.global_position, false)


func idle():
	if direction == "left":
		$AnimatedSprite.play("idle side")
		$AnimatedSprite.flip_h = true
	elif direction == "right":
		$AnimatedSprite.play("idle side")
		$AnimatedSprite.flip_h = false
	else: 
		$AnimatedSprite.play("idle " + direction)

func move():
	if not swinging:
		if worldNavigation != null and player != null:
			velocity = move_and_slide(velocity)
			if position.distance_to(player.position) > 50:
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
	if player:
		generate_path()
		navigate()
