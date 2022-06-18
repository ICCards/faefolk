extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety

func _ready():
	rng.randomize()
	variety = rng.randi_range(1, 20)
	$Sprite.texture = load("res://Assets/Images/flowers/" + str(variety) + ".png")


func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

var bodyEnteredFlag = false


func _on_Area2D_body_entered(_body):
	play_sound_effect()
	bodyEnteredFlag = true


func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
