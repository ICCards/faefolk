extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false
var bodyEnteredFlag2 = false
var grass
var biome
var grass_list
var front_health
var back_heath
var loc
var is_front_visible = true
var is_back_visible = true

var type

func _ready():
	PlayerData.connect("season_changed", self,  "set_grass_texture")
	hide()
	rng.randomize()
	front_health = rng.randi_range(1,3)
	back_heath = rng.randi_range(1,3)
	if biome == "snow":
		$FrontBreak.self_modulate = Color("7dd7b4")
		$BackBreak.self_modulate = Color("7dd7b4")
		grass = Images.green_grass_winter
	else:
		$FrontBreak.self_modulate = Color("99cc25")
		$BackBreak.self_modulate = Color("99cc25")
		grass = Images.green_grass
	$Front.texture = grass[0]
	$Back.texture = grass[1]
	set_grass_texture()
	
func set_grass_texture():
	var szn = PlayerData.player_data["season"]
	if szn == "Spring":
		type = "green grass"
		if biome == "snow":
			$FrontBreak.self_modulate = Color("7dd7b4")
			$BackBreak.self_modulate = Color("7dd7b4")
			grass = Images.green_grass_winter
		else:
			$FrontBreak.self_modulate = Color("99cc25")
			$BackBreak.self_modulate = Color("99cc25")
			grass = Images.green_grass
		$Front.texture = grass[0]
		$Back.texture = grass[1]
	elif szn == "Summer":
		type = "yellow grass"
		if biome == "snow":
			$FrontBreak.self_modulate = Color("f0e2c7")
			$BackBreak.self_modulate = Color("f0e2c7")
			grass = Images.yellow_grass_winter
		else:
			$FrontBreak.self_modulate = Color("ffec27")
			$BackBreak.self_modulate = Color("ffec27")
			grass = Images.yellow_grass
		$Front.texture = grass[0]
		$Back.texture = grass[1]
	elif szn == "Fall":
		type = "red grass"
		if biome == "snow":
			$FrontBreak.self_modulate = Color("beb6b5")
			$BackBreak.self_modulate = Color("beb6b5")
			grass = Images.red_grass_winter
		else:
			$FrontBreak.self_modulate = Color("e27432")
			$BackBreak.self_modulate = Color("e27432")
			grass = Images.red_grass
		$Front.texture = grass[0]
		$Back.texture = grass[1]
	elif szn == "Winter":
		type = "dark green grass"
		if biome == "snow":
			$FrontBreak.self_modulate = Color("a5ffbf")
			$BackBreak.self_modulate = Color("a5ffbf")
			grass = Images.dark_green_grass_winter
		else:
			$FrontBreak.self_modulate = Color("4b6d00")
			$BackBreak.self_modulate = Color("4b6d00")
			grass = Images.dark_green_grass
		$Front.texture = grass[0]
		$Back.texture = grass[1]



func play_hit_effect():
	if !bodyEnteredFlag and Server.isLoaded and visible:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate front")
		
func play_back_effect():
	if !bodyEnteredFlag2 and Server.isLoaded and visible:
#		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
#		$SoundEffects.play()
		$AnimationPlayer2.play("animate back")

func _on_Area2D_body_entered(_body):
	play_hit_effect()
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false



func _on_BackArea2D_body_entered(body):
	play_back_effect()
	bodyEnteredFlag2 = true

func _on_BackArea2D_body_exited(body):
	bodyEnteredFlag2 = false


func _on_Area2D_area_entered(area):
	front_health -= 1
	if front_health == 0:
		$AnimationPlayer.play("animate front")
		yield(get_tree().create_timer(rand_range(0.0, 0.25)), "timeout")
		if Util.chance(50):
			PlayerData.player_data["collections"]["forage"][type] += 1
			InstancedScenes.intitiateItemDrop(type,position+Vector2(0,-16),1)
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sund", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("front break")
		yield($AnimationPlayer, "animation_finished")
		is_front_visible = false
		destroy()
	else:
		yield(get_tree().create_timer(rand_range(0.0, 0.5)), "timeout")
		$AnimationPlayer.play("animate front")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()

func _on_BackArea2D_area_entered(area):
	back_heath -= 1
	if back_heath == 0:
		$AnimationPlayer.play("animate front")
		yield(get_tree().create_timer(rand_range(0.0, 0.25)), "timeout")
		if Util.chance(50):
			PlayerData.player_data["collections"]["forage"][type] += 1
			InstancedScenes.intitiateItemDrop(type,position+Vector2(0,-8), 1)
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer2.play("back break")
		yield($AnimationPlayer2, "animation_finished")
		is_back_visible = false
		destroy()
	else:
		yield(get_tree().create_timer(rand_range(0.1, 0.5)), "timeout")
		$AnimationPlayer2.play("animate back")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()

func destroy():
	if not is_back_visible and not is_front_visible:
		MapData.world["tall_grass"].erase(name)
		Tiles.add_valid_tiles(loc)
		queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
