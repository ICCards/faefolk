extends Node2D

@onready var RippleParticles = load("res://World/Player/Player/Fishing/RippleParticles.tscn")

@onready var progress = $CanvasLayer/CastingProgress
@onready var progress_background = $CanvasLayer/ProgressBackground
@onready var line = $Line2D
@onready var hook = $CastedFishHook
@onready var sound_effects: AudioStreamPlayer = $SoundEffects

@onready var player_animation_player = Server.player_node.animation_player
@onready var composite_sprites = Server.player_node.composite_sprites

@onready var ItemDrop = load("res://InventoryLogic/ItemDrop.tscn")

var in_casting_state: bool = false
var mini_game_active: bool = false
var click_to_start_mini_game: bool = false
var waiting_for_fish_bite: bool = false
var is_reeling_in_fish: bool = false
var is_progress_going_upwards: bool = true
var is_bob_moving_upwards: bool = true
#var moving_bob: bool = true

var start_point
var end_point
var mid_point
var cast_distance
var direction
var adjusted_end_point
var temp_end_point
var temp
var rng = RandomNumberGenerator.new()

var fishing_rod_type

const MIN_FISH_BITE_TIME = 1
const MAX_FISH_BITE_TIME = 3

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
			if click_to_start_mini_game:
				start_fishing_mini_game()
			elif waiting_for_fish_bite:
				retract_and_stop(null)

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
		elif (Input.is_action_just_released("mouse_click") or Input.is_action_just_released("use_tool")):
			cast()
		var r = remap(progress.value, 10, 100, 1, 0)
		var g = remap(progress.value, 10, 50, 0, 1)
		progress.modulate = Color(r, g, 0)
	elif waiting_for_fish_bite:
		setLinePointsToBezierCurve(start_point, Vector2(0, 0), mid_point, hook.position + Vector2(4.5,4.5))
	elif is_reeling_in_fish:
		$CaughtFish.position = hook.position + Vector2(4.5,4.5)
		line.points = [start_point, hook.position + Vector2(4.5,4.5)]

func retract_and_stop(fish_name):
	play_ripple_effect()
	$RippleTimer.stop()
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/pullItemFromWater.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	waiting_for_fish_bite = false
	if fish_name:
		$CaughtFish.show()
		$CaughtFish.texture = load("res://Assets/Images/inventory_icons/Fish/" + fish_name + ".png")
	reel_in_fish_line()
	composite_sprites.set_player_animation(Server.player_node.character, "retract_" + direction.to_lower(), "fishing rod retract")
	player_animation_player.play("retract")
	await player_animation_player.animation_finished
	if fish_name:
		PlayerData.player_data["skill_experience"]["fishing"] += 1
		PlayerData.player_data["collections"]["fish"][fish_name] += 1
		PlayerData.pick_up_item(fish_name, 1, null)
		Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(fish_name, 1)
	stop_fishing_state()
	
func reel_in_fish_line():
	is_reeling_in_fish = true
	if direction == "RIGHT":
		start_point = Vector2(20,-40)
	elif direction == "LEFT":
		start_point = Vector2(-20,-40)
	elif direction == "DOWN":
		start_point = Vector2(-14,-54)
	elif direction == "UP":
		start_point = Vector2(14,-54)
	line.points = [start_point, end_point]
	var tween = get_tree().create_tween()
	tween.tween_property(hook, "position", start_point, 0.8)
	
func start_fishing_mini_game():
	waiting_for_fish_bite = false
	$AnimationPlayer.play("hit")
	$CanvasLayer/FishingMiniGame.set_active(fishing_rod_type)
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/fishHit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.25).timeout
	composite_sprites.set_player_animation(Server.player_node.character, "struggle_" + direction.to_lower(), "fishing rod struggle")
	player_animation_player.play("struggle")
	mini_game_active = true
	change_start_point_pos()
	line.points = [start_point, end_point]
	$CanvasLayer/FishingMiniGame.start()
	$RippleTimer.start()

func change_start_point_pos():
	match direction:
		"UP":
			start_point = Vector2(15,-52)
		"DOWN":
			start_point = Vector2(-12,-62)
		_:
			start_point += Vector2(0,-18)

func start():
	line.hide()
	rng.randomize()
	direction = Server.player_node.direction
	composite_sprites.set_player_animation(Server.player_node.character, "cast_" + direction.to_lower(), "fishing rod cast")
	player_animation_player.play("set cast first frame")
	await player_animation_player.animation_finished
	player_animation_player.stop()
	is_progress_going_upwards = true
	progress.value = 0
	progress_background.show()
	progress.show()
	in_casting_state = true
	
func stop_fishing_state():
	Server.player_node.state = MOVEMENT
	queue_free()

func caught_fish(fish_name):
	retract_and_stop(fish_name)
	
func lost_fish():
	retract_and_stop(null)

func _on_MoveBobTimer_timeout():
	if waiting_for_fish_bite:
		rng.randomize()
		if direction == "RIGHT" or direction == "LEFT":
			temp = end_point + Vector2(rng.randi_range(0, 0),rng.randi_range(-4, 4))
		else:
			temp = (end_point + Vector2(rng.randi_range(-4, 4),rng.randi_range(0, 0)))
		move_bob(temp)

func move_bob(end):
	var tween = get_tree().create_tween()
	tween.tween_property(hook, "position", end, 3)


func cast():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/cast.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	in_casting_state = false
	progress.hide()
	progress_background.hide()
	player_animation_player.play("cast")
	await player_animation_player.animation_finished
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
	var location = Tiles.ocean_tiles.local_to_map(hook.position + Server.player_node.position)
	if Tiles.isCenterBitmaskTile(location, Tiles.ocean_tiles): # valid cast
		play_ripple_effect()
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/dropItemInWater.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		waiting_for_fish_bite = true
		if direction == "RIGHT" or direction == "LEFT":
			player_animation_player.play("waiting for fish side")
		else:
			player_animation_player.play("waiting for fish upwards")
	else:
		await get_tree().create_timer(0.2).timeout
		stop_fishing_state()


func setLinePointsToBezierCurve(a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()

func set_moving_fish_line_position(progress_of_game):
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
	var location = Tiles.ocean_tiles.local_to_map(temp_end_point + Server.player_node.position)
	if Tiles.isCenterBitmaskTile(location, Tiles.ocean_tiles):
		adjusted_end_point = temp_end_point
		return temp_end_point 
	elif adjusted_end_point:
		return adjusted_end_point
	else:
		return end_point


func _on_FishBiteTimer_timeout():
	if waiting_for_fish_bite:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Fishing/fishBite.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		$AnimationPlayer.play("bite")
		click_to_start_mini_game = true
		await $AnimationPlayer.animation_finished
		click_to_start_mini_game = false


func _on_RippleTimer_timeout():
	play_ripple_effect()

func play_ripple_effect():
	var rippleParticles = RippleParticles.instantiate()
	rippleParticles.position = hook.position + Vector2(4.5,4.5)
	add_child(rippleParticles)
	
