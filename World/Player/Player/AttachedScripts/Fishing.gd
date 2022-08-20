extends Node2D

onready var progress = $CastingProgress
onready var line = $Line2D

var isCastingForFish: bool = false
var is_casted: bool = false
var isReelingInFish: bool = false
var isFishOnHook: bool = false
var is_progress_going_upwards: bool = true

var start_point = Vector2(0,0)
var end_point = Vector2(100,25)

var direction

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")

func start():
	print("START")
	player_animation_player.play("set cast first frame")
	yield(player_animation_player, "animation_finished")
	player_animation_player.stop()
	is_progress_going_upwards = true
	progress.value = 0
	progress.visible = true
	isCastingForFish = true
	
func stop():
	print("STOP")
	progress.visible = false
	isCastingForFish = false
	is_casted = false
	isReelingInFish = false
	isFishOnHook = false
	is_progress_going_upwards = true
	progress.value = 0


func _physics_process(delta):
	if not is_casted:
		if isCastingForFish:
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
	#			end_point = Vector2(progress.value*5, 25)
	#			setLinePointsToBezierCurve(cast_point, Vector2(0, 25), Vector2(0, 25), end_point)
				is_casted = true
				isCastingForFish = false
				cast()

func setLinePointsToBezierCurve(a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()


#func fish():
#	if state != FISHING:
#		cast()
#	elif Input.is_action_pressed("mouse_click") and isFishOnHook:
#		start_fishing_mini_game()
#	elif Input.is_action_pressed("mouse_click") and not isCastingForFish:
#		stop_fishing_mini_game()
		
func cast():
	player_animation_player.play("cast")
	yield(player_animation_player, "animation_finished")
	draw_cast_line()
	
	
func draw_cast_line():
	match direction:
		"RIGHT":
			start_point = Vector2(24,-24)
	
	end_point = Vector2( 100*(progress.value/progress.max_value), 0 )
	setLinePointsToBezierCurve(start_point, Vector2(30, 0), Vector2(30, 0), end_point )
	
#	if not isCastingForFish:
#		isCastingForFish = true
#		$DetectPathType/FootstepsSound.stream_paused = true
#		#state = FISHING
#		animation = "cast_" + direction.to_lower()
#		$CompositeSprites.set_player_animation(character, animation, "fishing rod cast")
#		animation_player.play(animation)
#		yield(animation_player, "animation_finished")
#		var pos = Util.set_swing_position(get_position(), direction)
#		var location = hoed_tiles.world_to_map(pos)
#		if ocean_tiles.get_cellv(location) != -1:
#			wait_for_fish_state()
#		else:
#			isCastingForFish = false
#			state = MOVEMENT

#func stop_fishing_mini_game():
#	animation = "retract_" + direction.to_lower()
#	$CompositeSprites.set_player_animation(character, animation, "fishing rod retract")
#	animation_player.play("retract")
#	yield(animation_player, "animation_finished")
#	isFishOnHook = false
#	isWaitingForFish = false
#	isCastingForFish = false
#	isReelingInFish = false
#	#state = MOVEMENT
		
#func wait_for_fish_state():
#	if not isWaitingForFish and state == FISHING:
#		isWaitingForFish = true
#		var randomWait = rng.randi_range(2, 4)
#		yield(get_tree().create_timer(randomWait), "timeout")
#		if isWaitingForFish:
#			$Fishing/AnimationPlayer.play("bite")
#			isFishOnHook = true
#			yield($Fishing/AnimationPlayer, "animation_finished")
#			isFishOnHook = false
#			isWaitingForFish = false
#			wait_for_fish_state()


#func start_fishing_mini_game():
#	if not isReelingInFish:
#		isReelingInFish = true
#		print("START FISHING GAME")
#		stop_fishing_mini_game()
