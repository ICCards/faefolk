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
var is_front_visible = true
var is_back_visible = true

func _ready():
	rng.randomize()
	front_health = rng.randi_range(1,3)
	back_heath = rng.randi_range(1,3)
	if biome == "snow":
		grass = Images.green_grass_winter
	else:
		$FrontBreak.self_modulate = Color("008d00")
		$BackBreak.self_modulate = Color("008d00")
		grass = Images.green_grass
	$Front.texture = grass[0]
	$Back.texture = grass[1]

#008d00

func PlayEffect(player_id):
	play_hit_effect()

func play_hit_effect():
	if !bodyEnteredFlag and Server.isLoaded:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate front")
		
func play_back_effect():
	if !bodyEnteredFlag2 and Server.isLoaded:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer2.play("animate back")

func _on_Area2D_body_entered(_body):
	var data = {"id": name, "n": "tall_grass", "d": "" }
	Server.action("ON_HIT", data)
	play_hit_effect()
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	
func _on_VisibilityNotifier2D_screen_exited():
	visible = false


func _on_BackArea2D_body_entered(body):
	play_back_effect()
	bodyEnteredFlag2 = true

func _on_BackArea2D_body_exited(body):
	bodyEnteredFlag2 = false


func _on_Area2D_area_entered(area):
	front_health -= 1
	if front_health == 0:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("front break")
		yield($AnimationPlayer, "animation_finished")
		is_front_visible = false
		destroy()
	else:
		$AnimationPlayer.play("animate front")
		yield(get_tree().create_timer(rand_range(0, 0.75)), "timeout")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()

func _on_BackArea2D_area_entered(area):
	back_heath -= 1
	if back_heath == 0:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer2.play("back break")
		yield($AnimationPlayer2, "animation_finished")
		is_back_visible = false
		destroy()
	else:
		$AnimationPlayer2.play("animate back")
		yield(get_tree().create_timer(rand_range(0, 0.75)), "timeout")
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()

func destroy():
	if not is_back_visible and not is_front_visible:
		queue_free()
