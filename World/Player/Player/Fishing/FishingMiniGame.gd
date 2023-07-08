extends Node2D

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

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
	$GameProgress.value = 250
	$GameProgress.modulate = Color(remap(20, 10, 100, 1, 0), remap(20, 10, 50, 0, 1), 0)
	set_fishing_rod_level()
	
	
func set_fishing_rod_level():
	get_node(fishing_rod_level).show()
	match fishing_rod_level:
		"wood fishing rod":
			MIN_Y = 85
			MAX_Y = -19
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y
		"stone fishing rod":
			MIN_Y = 83
			MAX_Y = -17
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y
		"gold fishing rod":
			MIN_Y = 81
			MAX_Y = -15
			get_node(fishing_rod_level).position.y = MIN_Y
			$TempFishIcon.position.y = MIN_Y

func spawn_fish():
	var f = fish.instantiate()
	f.position = Vector2(get_node(fishing_rod_level).position.x, get_node(fishing_rod_level).position.y)
	add_child(f)
	fishable = false

func start():
	start_game_timer()
	get_node("Fish").start()
	
func start_game_timer():
	$GameTimer.set_wait_time(get_node("Fish").game_timer) 
	$GameTimer.start()
	var tween = get_tree().create_tween()
	print(get_node("Fish").game_timer)
	tween.tween_property($TimerProgress, "value", 0, float(get_node("Fish").game_timer))

func _physics_process(delta):
	if get_node("../../").mini_game_active:
		if ($Clicker.button_pressed == true):
			play_reel_sound_effects(true)
			if hookVelocity > -maxVelocity:
				hookVelocity -= hookAcceleration
		else:
			play_reel_sound_effects(false)
			if hookVelocity < maxVelocity:
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
			if get_node(fishing_rod_level + "/Area2D").get_overlapping_areas().size() > 0:
				get_node(fishing_rod_level).modulate = Color("ffffff")
				$GameProgress.value += 195 * delta
				if ($GameProgress.value >= 999):
					caught_fish()
			else:
				get_node(fishing_rod_level).modulate = Color("ffffff7d")
				$GameProgress.value -= 195 * delta
				if ($GameProgress.value <= 0):
					lost_fish()
		var r = remap($GameProgress.value/10, 10, 100, 1, 0)
		var g = remap($GameProgress.value/10, 10, 50, 0, 0.8)
		$GameProgress.modulate = Color(r, g, 0)
		get_node("../../").set_moving_fish_line_position($GameProgress.value)
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
	hide()
	get_node("../../").caught_fish(get_node("Fish").fish_data[0])
	get_node("../../").mini_game_active = false
	get_node("Fish").stop_fish_movement()
	
func lost_fish():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/fishEscape.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
	get_node("../../").mini_game_active = false
	$AnimationPlayer.play("fade")
	get_node("Fish").stop_fish_movement()
	get_node("../../").lost_fish()

func _on_Clicker_button_down():
	hookVelocity -= .5

func _on_GameTimer_timeout():
	lost_fish()
