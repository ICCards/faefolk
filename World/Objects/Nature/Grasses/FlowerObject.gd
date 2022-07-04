extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false


func _ready():
	rng.randomize()
	variety = rng.randi_range(1, 20)
	$Sprite.texture = load("res://Assets/Images/flowers/" + str(variety) + ".png")

func PlayEffect(player_id):
	play_sound_effect()

func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

func _on_Area2D_body_entered(_body):
	var data = {"id": name, "n": "flower", "d": ""}
	Server.action("ON_HIT", data)
	play_sound_effect()
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
