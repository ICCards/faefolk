extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety
var random_num
var location
var bodyEnteredFlag = false

var varieties = ["A", "B", "C", "D"]

func _ready():
	rng.randomize()
	varieties.shuffle()
	variety = varieties.front()
	random_num = rng.randi_range(1, 4)
	$Sprite.texture = load("res://Assets/Images/Weeds/" + variety + str(random_num) + ".png")
	set_leaf_break_modulate()
	
func set_leaf_break_modulate():
	match variety:
		"A":
			$LeafBreak.modulate = Color("28ad49")
		"B":
			$LeafBreak.modulate = Color("fcbe72")
		"C":
			$LeafBreak.modulate = Color("85ad28")
		"D":
			$LeafBreak.modulate = Color("4e876e")


func PlayEffect(player_id):
	play_sound_effect()

func play_sound_effect():
	if !bodyEnteredFlag and Server.isLoaded and visible:
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
		$SoundEffects.play()
		$AnimationPlayer.play("animate")

func _on_Area2D_body_entered(_body):
#	var data = {"id": name, "n": "flower", "d": ""}
#	Server.action("ON_HIT", data)
	play_sound_effect()
	bodyEnteredFlag = true

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false

func _on_Area2D_area_entered(area):
	Tiles.add_valid_tiles(location)
	Server.generated_map["flower"].erase(name)
	$Sprite.hide()
	$LeafBreak.show()
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -24)
	$SoundEffects.play()
	$LeafBreak.playing = true
	yield($LeafBreak, "animation_finished")
	queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	show()
	
func _on_VisibilityNotifier2D_screen_exited():
	hide()
