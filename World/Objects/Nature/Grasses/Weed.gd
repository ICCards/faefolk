extends Node2D

onready var rng = RandomNumberGenerator.new()
var variety
var random_num
var location
var bodyEnteredFlag = false
var destroyed = false

var varieties = ["A", "B", "C", "D"]

func _ready():
	visible = false
	rng.randomize()
	varieties.shuffle()
	variety = varieties.front()
	random_num = rng.randi_range(1, 4)
	$Sprite.set_deferred("texture", load("res://Assets/Images/Weeds/" + variety + str(random_num) + ".png"))
	call_deferred("set_leaf_break_modulate")
	
	
func remove_from_world():
	$Area2D.call_deferred("queue_free")
	call_deferred("queue_free")
	
	
func set_leaf_break_modulate():
	match variety:
		"A":
			$LeafBreak.set_deferred("modulate", Color("28ad49"))
		"B":
			$LeafBreak.set_deferred("modulate", Color("fcbe72"))
		"C":
			$LeafBreak.set_deferred("modulate", Color("85ad28"))
		"D":
			$LeafBreak.set_deferred("modulate", Color("4e876e"))


func play_sound_effect():
	if !bodyEnteredFlag and Server.isLoaded and visible:
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")
		$AnimationPlayer.call_deferred("play", "animate")

func _on_Area2D_body_entered(_body):
	$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
	$SoundEffects.call_deferred("play")
	$AnimationPlayer.call_deferred("play", "animate")

func _on_Area2D_body_exited(_body):
	bodyEnteredFlag = false

func _on_Area2D_area_entered(area):
	if not destroyed:
		destroyed = true
		Tiles.add_valid_tiles(location)
		if MapData.world["tall_grass"].has(name):
			MapData.world["tall_grass"].erase(name)
		$Sprite.call_deferred("hide")
		$LeafBreak.call_deferred("show")
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")
		$LeafBreak.set_deferred("playing", true)
		yield($LeafBreak, "animation_finished")
		queue_free()


func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
