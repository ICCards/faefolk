extends StaticBody2D

onready var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
onready var worldNavigation = get_node("/root/World/WorldNavigation")
onready var los = $LineOfSight
var player_spotted: bool = false
var random_idle_pos = null
var is_walking: bool = false
var is_in_sight: bool = false
var is_dead: bool = false
var path: Array = []
var fly_position
var player
const WALK_SPEED: int = 80
const FLY_SPEED: int = 120

var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	Images.BirdVariations.shuffle()
	$AnimatedSprite.frames = Images.BirdVariations[0]

func _physics_process(delta):
	if is_in_sight:
		player = get_node("/root/World/Players/" + Server.player_id)
		if player:
			los.look_at(player.global_position)
			check_player_in_detection()
			if player_spotted:
				if fly_position == null:
					rng.randomize()
					fly_position = position + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
					set_flight_direction(fly_position)
				fly(delta)
			else:
				walk(delta)


func set_flight_direction(new_pos):
	var tempPos = position - new_pos
	if tempPos.x < 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	if abs(tempPos.x) > abs(tempPos.y):
		$AnimatedSprite.play("fly side")
	elif tempPos.y < 0:
		$AnimatedSprite.play("fly down")
	else: 
		$AnimatedSprite.play("fly up")


func fly(delta):
	position = position.move_toward(fly_position, delta * FLY_SPEED)


func walk(delta):
	navigate(delta)



func navigate(delta):
	if path.size() > 0:
		set_direction(path[0])
		position = position.move_toward(path[0], delta * WALK_SPEED)
		if position == path[0]:
			path.pop_front()
	else:
		rng.randomize()
		random_idle_pos = Vector2(rng.randi_range(-800, 800), rng.randi_range(-800, 800))
		path = worldNavigation.get_simple_path(position, position + random_idle_pos, true)

func set_direction(new_pos):
	var tempPos = position - new_pos
	if tempPos.x < 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	if abs(tempPos.x) > abs(tempPos.y):
		$AnimatedSprite.play("walk side")
	elif tempPos.y < 0:
		$AnimatedSprite.play("walk down")
	else: 
		$AnimatedSprite.play("walk up")



func check_player_in_detection() -> bool:
	if not player.is_player_dead:
		var collider = los.get_collider()
		if collider and collider == player:
			player_spotted = true
			return true
		else:
			player_spotted = false
			fly_position = null
		return false
	return false



func _on_VisibilityNotifier2D_screen_entered():
	is_in_sight = true

func _on_VisibilityNotifier2D_screen_exited():
	is_in_sight = false
