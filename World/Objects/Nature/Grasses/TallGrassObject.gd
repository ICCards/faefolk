extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false
var bodyEnteredFlag2 = false
var grass
var biome
var grass_list

func _ready():
	if biome == "snow":
		grass = Images.green_grass_winter
	else:
		grass = Images.green_grass
	#grass = Images.returnTallGrassObject(biome, str(variety))
	$Front.texture = grass[0]
	$Back.texture = grass[1]

#func get_grass():
#	print(variety)
##	if biome == "snow":
##		grass_list = [Images.dark_green_grass_winter, Images.green_grass_winter, Images.yellow_grass_winter, Images.red_grass_winter]
##	else:
##		grass_list = [Images.dark_green_grass, Images.green_grass, Images.yellow_grass, Images.red_grass]
#	match variety:
#		"1":
#			$Front.texture = Images.dark_green_grass[0]
#			$Back.texture = Images.dark_green_grass[1]
#			#grass = Images.dark_green_grass
#		"2": 
#			print("var2")
#			$Front.texture = Images.green_grass[0]
#			$Back.texture = Images.green_grass[1]
#			#grass = Images.green_grass
#		"3":
#			$Front.texture = Images.yellow_grass[0]
#			$Back.texture = Images.yellow_grass[1]
#			#grass = Images.yellow_grass
#		"4": 
#			$Front.texture = Images.red_grass[0]
#			$Back.texture = Images.red_grass[1]
#			#grass = Images.red_grass

func PlayEffect(player_id):
	play_sound_effect()

func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate front")
		
func play_back_effect():
	if !bodyEnteredFlag2:
		$AnimationPlayer2.play("animate back")

func _on_Area2D_body_entered(_body):
	var data = {"id": name, "n": "tall_grass", "d": "" }
	Server.action("ON_HIT", data)
	play_sound_effect()
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
