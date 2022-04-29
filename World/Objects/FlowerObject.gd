extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety

func _ready():
	rng.randomize()
	variety = rng.randi_range(1, 20)
	$Sprite.texture = load("res://Assets/flowers/" + str(variety) + ".png")


func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

var bodyEnteredFlag = false


func _on_Area2D_body_entered(body):
	play_sound_effect()
	bodyEnteredFlag = true


func _on_Area2D_body_exited(body):
	bodyEnteredFlag = false
