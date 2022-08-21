extends Node2D

onready var progress = $CastingProgress
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

var start_point
var end_point
var mid_point
var direction

var rng = RandomNumberGenerator.new()

const MIN_FISH_BITE_TIME = 5
const MAX_FISH_BITE_TIME = 10

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
	mini_game_active = true
	$FishingMiniGame.spawn_random_fish()


func start():
	direction = get_parent().direction
	get_parent().state = FISHING
	composite_sprites.set_player_animation(get_parent().character, "cast_" + direction.to_lower(), "fishing rod cast")
	player_animation_player.play("set cast first frame")
	yield(player_animation_player, "animation_finished")
	player_animation_player.stop()
	is_progress_going_upwards = true
	progress.value = 0
	progress.visible = true
	in_casting_state = true
	
func stop_fishing_state():
	hook.visible = false
	line.visible = false
	progress.visible = false
	in_casting_state = false
	waiting_for_fish_bite = false
	mini_game_active = false
	click_to_start_mini_game = false
	$FishingMiniGame.hide()
	get_parent().state = MOVEMENT


func caught_fish():
	#SHOW FISH HERE
	retract_and_stop()
	
func lost_fish():
	stop_fishing_state()


func _physics_process(delta):
	if in_casting_state:
		if Input.is_action_pressed("mouse_click"):
			if is_progress_going_upwards:
				progress.value += 1
				if progress.value == progress.max_value:
					is_progress_going_upwards = false
			else:
				progress.value -= 1
				if progress.value == progress.min_value:
					is_progress_going_upwards = true
		elif Input.is_action_just_released("mouse_click"):
			cast()

func cast():
	in_casting_state = false
	progress.hide()
	player_animation_player.play("cast")
	yield(player_animation_player, "animation_finished")
	draw_cast_line()


func draw_cast_line():
	var percent = progress.value/progress.max_value
	match direction:
		"RIGHT":
			start_point = Vector2(24,-26)
			end_point = Vector2( 100*percent + 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
		"LEFT":
			start_point = Vector2(-24,-26)
			end_point = Vector2( -100*percent - 36, 0 )
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
		"DOWN":
			start_point = Vector2(1,-2)
			end_point = Vector2( 1, 100*percent + 8)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
		"UP":
			start_point = Vector2(-1,-56)
			end_point = Vector2( -1, -100*percent - 60)
			mid_point = Vector2(-(end_point.x-start_point.x)/2, 0)
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
