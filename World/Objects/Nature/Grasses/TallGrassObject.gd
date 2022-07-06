extends Node2D


onready var rng = RandomNumberGenerator.new()
var variety
var bodyEnteredFlag = false

func initialize(_variety):
	variety = _variety

func _ready():
	rng.randomize()
	$Sprite.texture = Images.tall_grass[rng.randi_range(0, 3)]

func PlayEffect(player_id):
	play_sound_effect()

func play_sound_effect():
	if !bodyEnteredFlag:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

func _on_Area2D_body_entered(_body):
	var data = {"id": name, "n": "tall_grass", "d": "" }
	Server.action("ON_HIT", data)
	play_sound_effect()
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false
