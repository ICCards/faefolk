extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety

func initialize(varietyInput):
	variety = varietyInput

func _ready():
	rng.randomize()
	$Sprite.texture = Images.tall_grass[rng.randi_range(0, 3)]
#	$Area2D.get_overlapping_bodies()
#	if $Area2D.get_overlapping_areas().size() > 0:
#		print('renove tall grass')
#		queue_free()


func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.volume_db = -80 #Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

var bodyEnteredFlag = false


func _on_Area2D_body_entered(_body):
	play_sound_effect()
	bodyEnteredFlag = true


func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
