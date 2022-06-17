extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety

func initialize(varietyInput):
	variety = varietyInput

func _ready():
	$Sprite.texture = load("res://Assets/Images/tall grass sets/" + variety + ".png")
	if not $Area2D.get_overlapping_areas().empty():
		queue_free()


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
