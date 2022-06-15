extends Node2D

onready var oreChip1 = $OreChips/OreChip1
onready var oreChip2 = $OreChips/OreChip2
onready var oreChip3 = $OreChips/OreChip3
onready var oreChip4 = $OreChips/OreChip4
onready var oreChip5 = $OreChips/OreChip5
onready var animationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()

var oreObject
var effectType
func init(oreTypeInput, effectTypeInput):
	oreObject = oreTypeInput
	effectType = effectTypeInput
	
func _ready():
	rng.randomize()
	setTexture(oreObject)
	if effectType == "ore hit":
		animationPlayer.play("ore hit " + str(rng.randi_range(1, 3)))
	if effectType == "ore break":
		animationPlayer.play("ore break")
		
	yield(animationPlayer, "animation_finished")
	queue_free()

func setTexture(ore):
	oreChip1.texture = ore.chip
	oreChip2.texture = ore.chip
	oreChip3.texture = ore.chip
	oreChip4.texture = ore.chip
	oreChip5.texture = ore.chip


