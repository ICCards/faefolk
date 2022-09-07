extends Node2D

var hookVelocity = 0.0;
var hookAcceleration = 0.05;
var hookDeceleration = 0.06;
var maxVelocity = 3;
var bounce = 0.4

var fishable = true
var fish = preload("res://World/Player/Player/Fishing/Fish.tscn")

func set_active():
	visible = true
	spawn_fish()
	modulate = Color(1,1,1,1)
	$Hook.position.y = 83
	$TempFishIcon.position.y = 83
	$Progress.value = 250
	$Progress.modulate = Color(range_lerp(20, 10, 100, 1, 0), range_lerp(20, 10, 50, 0, 1), 0)

func spawn_fish():
	var f = fish.instance()
	f.position = Vector2($Hook.position.x, $Hook.position.y)
	add_child(f)
	fishable = false

func start():
	start_game_timer()
	get_node("Fish").start()
	
func start_game_timer():
	$GameTimer.set_wait_time(get_node("Fish").game_timer) 
	$GameTimer.start()
	$Tween.interpolate_property($TimerProgress, "rect_size",
		Vector2(3,128), Vector2(3,0), get_node("Fish").game_timer,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(delta):
	if get_parent().mini_game_active:
		if ($Clicker.pressed == true):
			if hookVelocity > -maxVelocity:
				$AnimatedReel.rotation_degrees += 18
				hookVelocity -= hookAcceleration
		else:
			if hookVelocity < maxVelocity:
				$AnimatedReel.rotation_degrees -= 4
				hookVelocity += hookDeceleration

		if (Input.is_action_just_pressed("ui_accept")):
			hookVelocity -= .5

		var target = $Hook.position.y + hookVelocity
		if (target >= 83):
			hookVelocity *= -bounce
		elif (target <= -21):
			hookVelocity = 0
			$Hook.position.y = -21
		else:
			$Hook.position.y = target

		# Adjust Value
		if (fishable == false):
			if (len($Hook/Area2D.get_overlapping_areas()) > 0):
				$Hook.modulate = Color("ffffff")
				$Progress.value += 195 * delta
				if ($Progress.value >= 999):
					caught_fish()
			else:
				$Hook.modulate = Color("7dffffff")
				$Progress.value -= 195 * delta
				if ($Progress.value <= 0):
					lost_fish()
		var r = range_lerp($Progress.value/10, 10, 100, 1, 0)
		var g = range_lerp($Progress.value/10, 10, 50, 0, 1)
		$Progress.modulate = Color(r, g, 0)
		get_parent().set_moving_fish_line_position($Progress.value)


func caught_fish():
	$Tween.stop_all()
	hide()
	get_parent().caught_fish(get_node("Fish").fish_data[0])
	get_parent().mini_game_active = false
	get_node("Fish").stop_fish_movement()
	
func lost_fish():
	$Tween.stop_all()
	get_parent().mini_game_active = false
	$AnimationPlayer.play("fade")
	get_node("Fish").stop_fish_movement()
	get_parent().lost_fish()

func _on_Clicker_button_down():
	hookVelocity -= .5

func _on_GameTimer_timeout():
	lost_fish()
