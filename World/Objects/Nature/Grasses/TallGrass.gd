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
var destroyed: bool = false

var type

func _ready():
	rng.randomize()
	visible = false
	PlayerData.connect("season_changed", self,  "set_grass_texture")
	set_deferred("front_health", rng.randi_range(1,3))
	set_deferred("back_heath", rng.randi_range(1,3))
	set_grass_texture()
	
func remove_from_world():
	$Area2D.call_deferred("queue_free")
	$BackArea2D.call_deferred("queue_free")
	call_deferred("queue_free")
	
	
func set_grass_texture():
	var szn = PlayerData.player_data["season"]
	if szn == "spring":
		type = "green grass"
		if biome == "snow":
			$FrontBreak.set_deferred("self_modulate", Color("7dd7b4"))
			$BackBreak.set_deferred("self_modulate", Color("7dd7b4"))
			grass = Images.green_grass_winter
		else:
			$FrontBreak.set_deferred("self_modulate", Color("99cc25"))
			$BackBreak.set_deferred("self_modulate", Color("99cc25"))
			grass = Images.green_grass
		$Front.texture = grass[0]
		$Back.texture = grass[1]
	elif szn == "summer":
		type = "yellow grass"
		if biome == "snow":
			$FrontBreak.set_deferred("self_modulate", Color("f0e2c7"))
			$BackBreak.set_deferred("self_modulate", Color("f0e2c7"))
			grass = Images.yellow_grass_winter
		else:
			$FrontBreak.set_deferred("self_modulate", Color("ffec27"))
			$BackBreak.set_deferred("self_modulate", Color("ffec27"))
			grass = Images.yellow_grass
		$Front.set_deferred("texture", grass[0])
		$Back.set_deferred("texture", grass[1])
	elif szn == "fall":
		type = "red grass"
		if biome == "snow":
			$FrontBreak.set_deferred("self_modulate", Color("beb6b5"))
			$BackBreak.set_deferred("self_modulate", Color("beb6b5"))
			grass = Images.red_grass_winter
		else:
			$FrontBreak.set_deferred("self_modulate", Color("e27432"))
			$BackBreak.set_deferred("self_modulate", Color("e27432"))
			grass = Images.red_grass
		$Front.set_deferred("texture", grass[0])
		$Back.set_deferred("texture", grass[1])
	elif szn == "winter":
		type = "dark green grass"
		if biome == "snow":
			$FrontBreak.set_deferred("self_modulate", Color("a5ffbf"))
			$BackBreak.set_deferred("self_modulate", Color("a5ffbf"))
			grass = Images.dark_green_grass_winter
		else:
			$FrontBreak.set_deferred("self_modulate", Color("4b6d00"))
			$BackBreak.set_deferred("self_modulate", Color("4b6d00"))
			grass = Images.dark_green_grass
		$Front.set_deferred("texture", grass[0])
		$Back.set_deferred("texture", grass[1])


func play_hit_effect():
	if !bodyEnteredFlag and Server.isLoaded and visible:
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -26))
		$SoundEffects.call_deferred("play")
		$AnimationPlayer.call_deferred("play", "animate front")
		
func play_back_effect():
	if !bodyEnteredFlag2 and Server.isLoaded and visible:
		$AnimationPlayer2.call_deferred("play", "animate back")

func _on_Area2D_body_entered(_body):
	$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -26))
	$SoundEffects.call_deferred("play")
	$AnimationPlayer.call_deferred("play", "animate front")

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false

func _on_BackArea2D_body_entered(body):
	$AnimationPlayer2.call_deferred("play", "animate back")

func _on_BackArea2D_body_exited(body):
	bodyEnteredFlag2 = false

func _on_Area2D_area_entered(area):
	front_health -= 1
	if front_health == 0:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.call_deferred("play", "animate front")
		yield(get_tree().create_timer(rand_range(0.0, 0.25)), "timeout")
		if Util.chance(50):
			PlayerData.player_data["collections"]["forage"][type] += 1
			InstancedScenes.intitiateItemDrop(type,position+Vector2(0,-16),1)
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")
		$AnimationPlayer.call_deferred("play", "front break")
		yield($AnimationPlayer, "animation_finished")
		is_front_visible = false
		call_deferred("destroy")
	else:
		yield(get_tree().create_timer(rand_range(0.0, 0.5)), "timeout")
		$AnimationPlayer.call_deferred("play", "animate front")
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")

func _on_BackArea2D_area_entered(area):
	back_heath -= 1
	if back_heath == 0:
		$BackArea2D/CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer2.call_deferred("play", "animate back")
		yield(get_tree().create_timer(rand_range(0.0, 0.25)), "timeout")
		if Util.chance(50):
			PlayerData.player_data["collections"]["forage"][type] += 1
			InstancedScenes.intitiateItemDrop(type,position+Vector2(0,-8), 1)
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")
		$AnimationPlayer2.call_deferred("play", "back break")
		yield($AnimationPlayer2, "animation_finished")
		is_back_visible = false
		call_deferred("destroy")
	else:
		yield(get_tree().create_timer(rand_range(0.1, 0.5)), "timeout")
		$AnimationPlayer2.call_deferred("play", "animate back")
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")

func destroy():
	if not is_back_visible and not is_front_visible and not destroyed:
		destroyed = true
		MapData.world["tall_grass"].erase(name)
		Tiles.add_valid_tiles(loc)
		call_deferred("queue_free")

func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
