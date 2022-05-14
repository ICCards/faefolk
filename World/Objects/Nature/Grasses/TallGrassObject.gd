extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety

func initialize(varietyInput):
	variety = varietyInput

func _ready():
	$Sprite.texture = load("res://Assets/Images/tall grass sets/" + variety + ".png")


func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

var bodyEnteredFlag = false


func _on_Area2D_body_entered(_body):
	play_sound_effect()
	bodyEnteredFlag = true


func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
