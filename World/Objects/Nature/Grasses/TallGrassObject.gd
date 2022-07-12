extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false
var bodyEnteredFlag2 = false
var grass

func initialize(_variety):
	variety = _variety

func _ready():
	rng.randomize()
	get_grass()
	$Front.texture = grass[0]
	$Back.texture = grass[1]

func get_grass():
	var grass_list = [Images.dark_green_grass, Images.green_grass, Images.yellow_grass, Images.red_grass]
	grass_list.shuffle()
	grass = grass_list[0]

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
