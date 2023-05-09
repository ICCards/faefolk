extends Node2D

@onready var rng = RandomNumberGenerator.new()
var variety
var random_num
var location
var bodyEnteredFlag = false
var destroyed = false

var varieties = ["A", "B", "C", "D"]

func _ready():
	rng.randomize()
	Tiles.add_navigation_tiles(location)
	varieties.shuffle()
	variety = varieties.front()
	random_num = rng.randi_range(1,4)
	$Weed/TileMap.set_cell(0,Vector2i(0,-1),0,Constants.weed_atlas_cords[variety+str(random_num)])
	call_deferred("set_leaf_break_modulate")


func remove_from_world():
	$Area2D.call_deferred("queue_free")
	call_deferred("queue_free")
	
	
func set_leaf_break_modulate():
	match variety:
		"A":
			$LeafBreak.set_deferred("modulate", Color("85ad28"))
		"B":
			$LeafBreak.set_deferred("modulate", Color("28ad49"))
		"C":
			$LeafBreak.set_deferred("modulate", Color("4e876e"))
		"D":
			$LeafBreak.set_deferred("modulate", Color("fcbe72"))



func play_sound_effect():
	if !bodyEnteredFlag:
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
		MapData.remove_object("tall_grass",name,location) 
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		$Weed/TileMap.call_deferred("hide")
		$LeafBreak.call_deferred("show")
		$SoundEffects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -24))
		$SoundEffects.call_deferred("play")
		$LeafBreak.call_deferred("play", "break")
		await $LeafBreak.animation_finished
		call_deferred("queue_free")

