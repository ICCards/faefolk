extends StaticBody2D

onready var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
onready var worldNavigation = get_node("/root/World/WorldNavigation")
onready var los = $LineOfSight
var player_spotted: bool = false
var random_idle_pos = null
var in_idle_state: bool = false
var is_dead: bool = false
var is_in_sight: bool = false
var path: Array = []
var player
const SPEED: int = 140
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	Images.DuckVariations.shuffle()
	$AnimatedSprite.frames = Images.DuckVariations[0]
	los.cast_to = Vector2(rng.randi_range(100, 400), 0)
	if Util.chance(50):
		$AnimatedSprite.flip_h = true


func _physics_process(delta):
	if is_in_sight:
		player = get_node("/root/World/Players/" + Server.player_id).get_children()[0]
		if player:
			los.look_at(player.global_position)
			check_player_in_detection()
			if player_spotted:
				move_randomly(delta)
			else:
				random_idle_pos = null
				$AnimatedSprite.play("idle")


func move_randomly(delta):
	if not is_dead:
		if random_idle_pos == null:
			$AnimatedSprite.play("walk")
			in_idle_state = false
			rng.randomize()
			random_idle_pos = Vector2(rng.randi_range(-300, 300), rng.randi_range(-300, 300))
			path = worldNavigation.get_simple_path(position, position + random_idle_pos, true)
		else:
			navigate(delta)

func set_direction(new_pos):
	var tempPos = position - new_pos
	if tempPos.x > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false


func navigate(delta):
	if path.size() > 0:
		set_direction(path[0])
		position = position.move_toward(path[0], delta * SPEED)
		if position == path[0]:
			path.pop_front()
	else:
		idle_state()


func idle_state():
	if not in_idle_state and not is_dead:
		in_idle_state = true
		randomize()
		yield(get_tree().create_timer(rand_range(0, 0.5)), "timeout")
		if Util.chance(33):
			$AnimatedSprite.play("eat")
			yield($AnimatedSprite, "animation_finished")
		random_idle_pos = null	



func check_player_in_detection() -> bool:
	if not player.is_player_dead:
		var collider = los.get_collider()
		if global_position.distance_to(player.global_position) >= 600:
			player_spotted = false
		if collider and collider == player:
			player_spotted = true
			return true
		return false
	return false


func _on_HurtBox_area_entered(area):
	is_dead = true
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("death")
	yield($AnimatedSprite, "animation_finished")
	$AnimationPlayer.play("death")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	is_in_sight = true


func _on_VisibilityNotifier2D_screen_exited():
	is_in_sight = false