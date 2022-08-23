extends Node2D

var hookVelocity = 0.0;
var hookAcceleration = 0.125;
var hookDeceleration = 0.225
var maxVelocity = 7.0;
var bounce = 0.6

var fishable = true;
var fish = preload("res://World/Fishing/Fish.tscn")


func set_active():
	visible = true
	$Hook.position = Vector2(10.5, 280)
	$TempFishIcon.show()
	$Progress.value = 200

func spawn_random_fish():
	$TempFishIcon.hide()
	$Hook.position.y = 280
	spawn_level1()
#	if Util.chance(25):
#		spawn_level1()
#	elif Util.chance(25):
#		spawn_level2()
#	elif Util.chance(25):
#		spawn_level3()
#	else:
#		spawn_level4()

func _physics_process(delta):
	if get_parent().mini_game_active:
		if ($Clicker.pressed == true):
			if hookVelocity > -maxVelocity:
				hookVelocity -= hookAcceleration
		else:
			if hookVelocity < maxVelocity:
				hookVelocity += hookDeceleration
				
		if (Input.is_action_just_pressed("ui_accept")):
			hookVelocity -= .5
			
		var target = $Hook.position.y + hookVelocity
		if (target >= 280):
			hookVelocity *= -bounce
		elif (target <= 38):
			hookVelocity = 0
			$Hook.position.y = 38
		else:
			$Hook.position.y = target
			
		# Adjust Value
		if (fishable == false):
			if (len($Hook/Area2D.get_overlapping_areas()) > 0):
				$Progress.value += 165 * delta
				if ($Progress.value >= 999):
					caught_fish()
			else:
				$Progress.value -= 155 * delta
				if ($Progress.value <= 0):
					lost_fish()
		get_parent().set_active_fish_line_position($Progress.value)
					
		
func caught_fish():
	print("CAUGHT")
	get_node("Fish").destroy()
	$Progress.value = 0
	fishable = true
	get_parent().caught_fish()
	
func lost_fish():
	print("LOST")
	get_node("Fish").destroy()
	$Progress.value = 0
	fishable = true
	get_parent().lost_fish()
	
func add_fish(min_d, max_d, move_speed, move_time):
	var f = fish.instance()
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
		add_fish(60, 120, 3, 1.75)
		fishable = false

func spawn_level2():
	print("LEVEL 2")
	if (fishable):
		add_fish(70, 140, 2.5, 1.5)
		fishable = false

func spawn_level3():
	print("LEVEL 3")
	if (fishable):
		add_fish(80, 160, 2, 1)
		fishable = false

func spawn_level4():
	print("LEVEL 4")
	if (fishable):
		add_fish(90, 160, 1.75, 0.75)
		fishable = false

func _on_Clicker_button_down():
	hookVelocity -= .5

