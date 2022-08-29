extends Node2D

onready var progress = $CastingProgress
onready var progress_background = $ProgressBackground
onready var line = $Line2D
onready var hook = $CastedFishHook

onready var ocean = get_node("/root/World/GeneratedTiles/AnimatedOceanTiles")
onready var player_animation_player = Server.player_node.animation_player
onready var composite_sprites = Server.player_node.composite_sprites

var in_casting_state: bool = false
var mini_game_active: bool = false
var click_to_start_mini_game: bool = false
var waiting_for_fish_bite: bool = false
var is_progress_going_upwards: bool = true
var is_bob_moving_upwards: bool = true
var move_bob: bool = true

var start_point
var end_point
var mid_point
var cast_distance
var direction
var adjusted_end_point
var temp_end_point
var temp
var rng = RandomNumberGenerator.new()

const MIN_FISH_BITE_TIME = 2
const MAX_FISH_BITE_TIME = 5

enum {
	MOVEMENT, 
	SWING,
	EAT,
	FISHING,
	CHANGE_TILE
}

func _ready():
	start()


func _unhandled_input(event):
	if event.is_action_pressed("mouse_click"):
		if not mini_game_active:
			$Tween.stop_all()
			if click_to_start_mini_game:
				start_fishing_mini_game()
			elif waiting_for_fish_bite:
				retract_and_stop()

func retract_and_stop():
	waiting_for_fish_bite = false
	Server.player_node.composite_sprites.set_player_animation(Server.player_node.character, "retract_" + direction.to_lower(), "fishing rod retract")
	player_animation_player.play("retract")
	yield(player_animation_player, "animation_finished")
	stop_fishing_state()
	
func start_fishing_mini_game():
	waiting_for_fish_bite = false
	$AnimationPlayer.play("hit")
	$FishingMiniGame.set_active()
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(0.25), "timeout")
	composite_sprites.set_player_animation(get_parent().character, "struggle_" + direction.to_lower(), "fishing rod struggle")
	player_animation_player.play("struggle")
	mini_game_active = true
	change_start_point_pos()
	line.points = [start_point, end_point]
	$FishingMiniGame.spawn_random_fish()

func change_start_point_pos():
	match direction:
		"UP":
			start_point = Vector2(15,-52)
		"DOWN":
			start_point = Vector2(-12,-62)
		_:
			start_point += Vector2(0,-18)

func start():
	rng.randomize()
	direction = Server.player_node.direction
	composite_sprites.set_player_animation(Server.player_node.character, "cast_" + direction.to_lower(), "fishing rod cast")
	player_animation_player.play("set cast first frame")
	yield(player_animation_player, "animation_finished")
	player_animation_player.stop()
	is_progress_going_upwards = true
	progress.value = 0
	progress_background.show()
	progress.show()
	in_casting_state = true
	
func stop_fishing_state():
	Server.player_node.state = MOVEMENT
	queue_free()

func caught_fish():
	$FishingMiniGame.hide()
	retract_and_stop()
	
func lost_fish():
	stop_fishing_state()

func _on_MoveBobTimer_timeout():
	if waiting_for_fish_bite:
		rng.randomize()
		if direction == "RIGHT" or direction == "LEFT":
			temp = end_point + Vector2(rng.randi_range(0, 0),rng.randi_range(-4, 4))
		else:
			temp = (end_point + Vector2(rng.randi_range(-4, 4),rng.randi_range(0, 0)))
		move_bob(end_point, temp)

func move_bob(start, end):
	$Tween.interpolate_property(hook, "position",
		start, end, 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta):
	if in_casting_state:
		if Input.is_action_pressed("mouse_click"):
			if is_progress_going_upwards:
				progress.value += 2
				if progress.value == progress.max_value:
					is_progress_going_upwards = false
			else:
				progress.value -= 2
				if progress.value == progress.min_value:
					is_progress_going_upwards = true
		elif Input.is_action_just_released("mouse_click"):
			cast()
		var r = range_lerp(progress.value, 10, 100, 1, 0)
		var g = range_lerp(progress.value, 10, 50, 0, 1)
		progress.modulate = Color(r, g, 0)
	elif waiting_for_fish_bite:
		setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, hook.position + Vector2(4.5,4.5))
		


func cast():
	in_casting_state = false
	progress.hide()
	progress_background.hide()
	player_animation_player.play("cast")
	yield(player_animation_player, "animation_finished")
	draw_cast_line()


func draw_cast_line():
	var percent = progress.value/progress.max_value
	match direction:
		"RIGHT":
			start_point = Vector2(28,-22)
			end_point = Vector2( 180*percent + 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = abs(start_point.x - end_point.x)
		"LEFT":
			start_point = Vector2(-28,-22)
			end_point = Vector2( -180*percent - 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = start_point.x - end_point.x
		"DOWN":
			start_point = Vector2(1,6)
			end_point = Vector2( 2, 160*percent + 8)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = abs(start_point.y - end_point.y) - 12
		"UP":
			start_point = Vector2(-1,-54)
			end_point = Vector2( 2, -160*percent - 60)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = start_point.y - end_point.y - 12
	line.show()
	hook.show()
	hook.position = end_point - Vector2(4.5, 4.5)
	setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, end_point )
	var location = ocean.world_to_map(hook.position + get_parent().position)
	#if Tiles.isCenterBitmaskTile(location, ocean): # valid cast
	waiting_for_fish_bite = true
	if direction == "RIGHT" or direction == "LEFT":
		player_animation_player.play("waiting for fish side")
	else:
		player_animation_player.play("waiting for fish upwards")
#	else:
#		yield(get_tree().create_timer(0.2),"timeout")
#		stop_fishing_state()


func setLinePointsToBezierCurve(a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()

func set_active_fish_line_position(progress_of_game):
	var temp_end_point = return_adjusted_end_point(progress_of_game)
	hook.position = temp_end_point - Vector2(4.5,4.5)
	line.points = [start_point, temp_end_point]

func return_adjusted_end_point(progress_of_game):
	match direction:
		"RIGHT":
			temp_end_point = end_point - Vector2(((progress_of_game-200)/800)*cast_distance, 0)
		"LEFT":
			temp_end_point = end_point + Vector2(((progress_of_game-200)/800)*cast_distance, 0)
		"UP":
			temp_end_point =  end_point + Vector2(0, ((progress_of_game-200)/800)*cast_distance)
		"DOWN":
			temp_end_point = end_point - Vector2(0, ((progress_of_game-200)/800)*cast_distance)
	var location = ocean.world_to_map(temp_end_point + get_parent().position)
	if Tiles.isCenterBitmaskTile(location, ocean):
		adjusted_end_point = temp_end_point
		return temp_end_point 
	else:
		return adjusted_end_point



func _on_FishBiteTimer_timeout():
	if waiting_for_fish_bite:
		$AnimationPlayer.play("bite")
		click_to_start_mini_game = true
		yield($AnimationPlayer, "animation_finished")
		click_to_start_mini_game = false
