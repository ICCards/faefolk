extends Node2D

onready var oreChip1: Sprite = $OreChips/OreChip1
onready var oreChip2: Sprite = $OreChips/OreChip2
onready var oreChip3: Sprite = $OreChips/OreChip3
onready var oreChip4: Sprite = $OreChips/OreChip4
onready var oreChip5: Sprite = $OreChips/OreChip5
onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var oreObject
var effect_type
var variety

func _ready():
	rng.randomize()
	oreObject = Images.returnOreObject(variety)
	setTexture()
	if effect_type == "ore hit":
		animation_player.play("ore hit " + str(rng.randi_range(1, 3)))
	elif effect_type == "large ore break":
		animation_player.play("ore break")
	elif effect_type == "ore destroyed":
		animation_player.play("ore break")
		play_particles()
	yield(get_tree().create_timer(1.5), "timeout")
	queue_free()


func play_particles():
	if variety == "stone2":
		$Particles.modulate = Color("c29c6b")
	elif variety == "iron ore":
		$Particles.modulate = Color("c3b779")
	elif variety == "bronze ore":
		$Particles.modulate = Color("946c38")
	elif variety == "gold ore":
		$Particles.modulate = Color("c79c3e")
	$Smoke.show()
	$Particles.show()
	$Smoke.play()
	$Particles.play()
	yield($Particles, "animation_finished")


func setTexture():
	oreChip1.texture = oreObject.chip
	oreChip2.texture = oreObject.chip
	oreChip3.texture = oreObject.chip
	oreChip4.texture = oreObject.chip
	oreChip5.texture = oreObject.chip


