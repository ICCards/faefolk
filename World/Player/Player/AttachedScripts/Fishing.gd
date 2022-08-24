extends Node2D

onready var progress = $CastingProgress
onready var progress_background = $ProgressBackground
onready var line = $Line2D
onready var hook = $CastedFishHook

onready var ocean = get_node("/root/World/GeneratedTiles/AnimatedOceanTiles")
onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")

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

func initialize():
	if get_parent().state != FISHING:
		start()
	else:
		if not mini_game_active:
			if click_to_start_mini_game:
				start_fishing_mini_game()
			elif waiting_for_fish_bite:
				retract_and_stop()

func retract_and_stop():
	waiting_for_fish_bite = false
	composite_sprites.set_player_animation(get_parent().character, "retract_" + direction.to_lower(), "fishing rod retract")
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
			start_point = Vector2(13,-55)
		"DOWN":
			start_point = Vector2(-12,-62)
		_:
			start_point += Vector2(0,-20)

func start():
	rng.randomize()
	direction = get_parent().direction
	get_parent().state = FISHING
	composite_sprites.set_player_animation(get_parent().character, "cast_" + direction.to_lower(), "fishing rod cast")
	player_animation_player.play("set cast first frame")
	yield(player_animation_player, "animation_finished")
	player_animation_player.stop()
	is_progress_going_upwards = true
	progress.value = 0
	progress_background.show()
	progress.show()
	in_casting_state = true
	
func stop_fishing_state():
	hook.hide()
	line.hide()
	progress.hide()
	in_casting_state = false
	waiting_for_fish_bite = false
	mini_game_active = false
	click_to_start_mini_game = false
	$FishingMiniGame.hide()
	get_parent().state = MOVEMENT


func caught_fish():
	#SHOW FISH HERE
	$FishingMiniGame.hide()
	retract_and_stop()
	
func lost_fish():
	stop_fishing_state()

func _on_MoveBobTimer_timeout():
	if waiting_for_fish_bite:
		if direction == "RIGHT" or direction == "LEFT":
			var temp_end_point = (end_point + Vector2(rng.randi_range(-1, 1),rng.randi_range(-2, 2)))
			hook.rect_position = temp_end_point - Vector2(3,3)
			setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, temp_end_point )
		else:
			var temp_end_point = (end_point + Vector2(rng.randi_range(-2, 2),rng.randi_range(-1, 1)))
			hook.rect_position = temp_end_point - Vector2(3,3)
			setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, temp_end_point )

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
		
		
func play_bobbing_motion():
	if direction == "RIGHT" or direction == "LEFT":
		if move_bob:
			move_bob = false
			if is_bob_moving_upwards:
				end_point += Vector2(0, 3)
				hook.rect_position = end_point - Vector2(3,3)
				setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, end_point )
			else:
				end_point += Vector2(0, -3)
				hook.rect_position = end_point - Vector2(3,3)
				setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, end_point )
			is_bob_moving_upwards = not is_bob_moving_upwards
			yield(get_tree().create_timer(1.5), "timeout")
			move_bob = true

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
			start_point = Vector2(24,-26)
			end_point = Vector2( 180*percent + 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = abs(start_point.x - end_point.x)
		"LEFT":
			start_point = Vector2(-24,-26)
			end_point = Vector2( -180*percent - 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = start_point.x - end_point.x
		"DOWN":
			start_point = Vector2(1,-2)
			end_point = Vector2( 2, 160*percent + 8)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = abs(start_point.y - end_point.y) - 12
		"UP":
			start_point = Vector2(-1,-56)
			end_point = Vector2( 2, -160*percent - 60)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
			cast_distance = start_point.y - end_point.y - 12
	line.show()
	hook.show()
	hook.rect_position = end_point - Vector2(3,3)
	setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, end_point )
	var location = ocean.world_to_map(hook.rect_position + get_parent().position)
	if Tiles.isCenterBitmaskTile(location, ocean): # valid cast
		waiting_for_fish_bite = true
		wait_for_fish_state()
	else:
		yield(get_tree().create_timer(0.2),"timeout")
		stop_fishing_state()


func wait_for_fish_state():
	rng.randomize()
	var randomWait = rng.randi_range(MIN_FISH_BITE_TIME, MAX_FISH_BITE_TIME)
	yield(get_tree().create_timer(randomWait), "timeout")
	if waiting_for_fish_bite:
		$AnimationPlayer.play("bite")
		click_to_start_mini_game = true
		yield($AnimationPlayer, "animation_finished")
		click_to_start_mini_game = false
		wait_for_fish_state()

func setLinePointsToBezierCurve(a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()

func set_active_fish_line_position(progress_of_game):
	var temp_end_point = return_adjusted_end_point(progress_of_game)
	hook.rect_position = temp_end_point - Vector2(3,3)
	line.points = [start_point, temp_end_point]

func return_adjusted_end_point(progress_of_game):
	match direction:
		"RIGHT":
#			if progress_of_game <= 200:	
			return end_point + Vector2(32*(1-(progress_of_game/200)), 0)
#			else:
#				return end_point + Vector2(32*(1-(progress_of_game/800)), 0)
		"LEFT":
			return end_point + Vector2(((progress_of_game-200)/800)*cast_distance, 0)
		"UP":
			return end_point + Vector2(0, ((progress_of_game-200)/800)*cast_distance)
		"DOWN":
			return end_point - Vector2(0, ((progress_of_game-200)/800)*cast_distance)

	
