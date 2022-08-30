extends Node2D

var hookVelocity = 0.0;
var hookAcceleration = 0.05;
var hookDeceleration = 0.06;
var maxVelocity = 3;
var bounce = 0.4

var fishable = true;
var fish = preload("res://World/Player/Player/Fishing/Fish.tscn")


func set_active():
	visible = true
	$TempFishIcon.show()
	$Hook.position.y = 83
	$TempFishIcon.position.y = 83
	$Progress.value = 200
	$Progress.modulate = Color(range_lerp(20, 10, 100, 1, 0), range_lerp(20, 10, 50, 0, 1), 0)

func spawn_random_fish():
	print("SPAWN RANDOM FISH")
	$TempFishIcon.hide()
	if Util.chance(25):
		spawn_level1()
	elif Util.chance(25):
		spawn_level2()
	elif Util.chance(25):
		spawn_level3()
	else:
		spawn_level4()

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
				$Progress.value += 175 * delta
				if ($Progress.value >= 999):
					caught_fish()
			else:
				$Hook.modulate = Color("7dffffff")
				$Progress.value -= 165 * delta
				if ($Progress.value <= 0):
					lost_fish()
		var r = range_lerp($Progress.value/10, 10, 100, 1, 0)
		var g = range_lerp($Progress.value/10, 10, 50, 0, 1)
		$Progress.modulate = Color(r, g, 0)
		get_parent().set_active_fish_line_position($Progress.value)
					
		
func caught_fish():
	print("CAUGHT")
	get_parent().mini_game_active = false
	get_node("Fish").destroy()
	$Progress.value = 0
	fishable = true
	get_parent().caught_fish()
	
func lost_fish():
	print("LOST")
	get_parent().mini_game_active = false
	get_node("Fish").destroy()
	$Progress.value = 0
	fishable = true
	get_parent().lost_fish()
	
func add_fish(min_d, max_d, move_speed, move_time):
	var f = fish.instance()
	f.season = "Spring"
	f.setting = "Sea"
	f.time = "Day"
	f.position = Vector2($Hook.position.x, $Hook.position.y)
	f.min_distance = min_d
	f.max_distance = max_d
	f.movement_speed = move_speed
	f.movement_time = move_time
	add_child(f)
	$Progress.value = 200
	fishable = false

func spawn_level1():
	print("LEVEL 1")
	if (fishable):
		add_fish(40, 120, 3, 1.75)
		fishable = false

func spawn_level2():
	print("LEVEL 2")
	if (fishable):
		add_fish(45, 140, 2.5, 1.5)
		fishable = false

func spawn_level3():
	print("LEVEL 3")
	if (fishable):
		add_fish(50, 160, 2, 1)
		fishable = false

func spawn_level4():
	print("LEVEL 4")
	if (fishable):
		add_fish(60, 160, 1.75, 0.75)
		fishable = false

func _on_Clicker_button_down():
	hookVelocity -= .5

