extends Node2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var hookVelocity = 0.0;
var hookAcceleration = 0.05;
var hookDeceleration = 0.06;
var maxVelocity = 3;
var bounce = 0.4

var fishable = true
var fish = load("res://World/Player/Player/Fishing/Fish.tscn")

var MIN_Y
var MAX_Y

var fishing_rod_level

func set_active(_fishing_rod_type):
	fishing_rod_level = _fishing_rod_type
	visible = true
	spawn_fish()
	modulate = Color(1,1,1,1)
	$Progress.value = 250
	#$Progress.modulate = Color(range_lerp(20, 10, 100, 1, 0), range_lerp(20, 10, 50, 0, 1), 0)
	set_fishing_rod_level()
	
	
func set_fishing_rod_level():
	get_node(fishing_rod_level).show()
	match fishing_rod_level:
		"wood fishing rod":
			MIN_Y = 83
			MAX_Y = -21
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y
		"stone fishing rod":
			MIN_Y = 81
			MAX_Y = -19
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y
		"gold fishing rod":
			MIN_Y = 79
			MAX_Y = -17
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y

func spawn_fish():
	var f = fish.instance()
	f.position = Vector2(get_node(fishing_rod_level).position.x, get_node(fishing_rod_level).position.y)
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
			play_reel_sound_effects(true)
			if hookVelocity > -maxVelocity:
				$AnimatedReel.rotation_degrees += 18
				hookVelocity -= hookAcceleration
		else:
			play_reel_sound_effects(false)
			if hookVelocity < maxVelocity:
				$AnimatedReel.rotation_degrees -= 4
				hookVelocity += hookDeceleration
		var target = get_node(fishing_rod_level).position.y + hookVelocity
		if (target >= MIN_Y):
			hookVelocity *= -bounce
		elif (target <= MAX_Y):
			hookVelocity = 0
			get_node(fishing_rod_level).position.y = MAX_Y
		else:
			get_node(fishing_rod_level).position.y = target

		# Adjust Value
		if (fishable == false):
			if (len(get_node(fishing_rod_level + "/Area2D").get_overlapping_areas()) > 0):
				get_node(fishing_rod_level).modulate = Color("ffffff")
				$Progress.value += 195 * delta
				if ($Progress.value >= 999):
					caught_fish()
			else:
				get_node(fishing_rod_level).modulate = Color("7dffffff")
				$Progress.value -= 195 * delta
				if ($Progress.value <= 0):
					lost_fish()
		#var r = range_lerp($Progress.value/10, 10, 100, 1, 0)
		#var g = range_lerp($Progress.value/10, 10, 50, 0, 0.8)
		#$Progress.modulate = Color(r, g, 0)
		get_parent().set_moving_fish_line_position($Progress.value)
	else:
		sound_effects.playing = false


func play_reel_sound_effects(is_being_pressed):
	if is_being_pressed:
		if sound_effects.stream != load("res://Assets/Sound/Sound effects/Fishing/fastReel.mp3"):
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/fastReel.mp3")
	else:
		if sound_effects.stream != load("res://Assets/Sound/Sound effects/Fishing/slowReel.mp3"):
			sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/slowReel.mp3")
	if not sound_effects.playing:
		sound_effects.playing = true


func caught_fish():
	$Tween.stop_all()
	hide()
	get_parent().caught_fish(get_node("Fish").fish_data[0])
	get_parent().mini_game_active = false
	get_node("Fish").stop_fish_movement()
	
func lost_fish():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/fishEscape.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
	$Tween.stop_all()
	get_parent().mini_game_active = false
	$AnimationPlayer.play("fade")
	get_node("Fish").stop_fish_movement()
	get_parent().lost_fish()

func _on_Clicker_button_down():
	hookVelocity -= .5

func _on_GameTimer_timeout():
	lost_fish()
