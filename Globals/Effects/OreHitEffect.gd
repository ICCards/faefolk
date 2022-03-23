extends Node2D

onready var oreChip1 = $OreChips/OreChip1
onready var oreChip2 = $OreChips/OreChip2
onready var oreChip3 = $OreChips/OreChip3
onready var oreChip4 = $OreChips/OreChip4
onready var oreChip5 = $OreChips/OreChip5
onready var animationPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()

var oreType
var effectType
func init(oreTypeInput, effectTypeInput):
	oreType = oreTypeInput
	effectType = effectTypeInput
	
func _ready():
	setOreTexture()
	if effectType == "big ore hit":
		selectRandomizedSprites()
		animationPlayer.play("Animate")
		
	if effectType == "small ore break":
		animationPlayer.play("small ore break")
		
	if effectType == "big ore break":
		animationPlayer.play("Animate")
		
	yield(animationPlayer, "animation_finished")
	queue_free()


var randomArray = [ 1, 1, 0, 0, 0]
func selectRandomizedSprites():
	rng.randomize()
	randomArray.shuffle()
	oreChip1.visible = randomArray[0] == 1
	oreChip2.visible = randomArray[1] == 1
	oreChip3.visible = randomArray[2] == 1
	oreChip4.visible = randomArray[3] == 1
	oreChip5.visible = randomArray[4] == 1

func setOreTexture():
	if (oreType == 'red'):
		oreChip1.texture = Images.redOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.redOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.redOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.redOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.redOreChips[rng.randi_range(0, 1)]
	if (oreType == 'green'):
		oreChip1.texture = Images.greenOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.greenOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.greenOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.greenOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.greenOreChips[rng.randi_range(0, 1)]
	if (oreType == 'dark blue'):
		oreChip1.texture = Images.darkBlueOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.darkBlueOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.darkBlueOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.darkBlueOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.darkBlueOreChips[rng.randi_range(0, 1)]
	if (oreType == 'cyan'):
		oreChip1.texture = Images.cyanOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.cyanOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.cyanOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.cyanOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.cyanOreChips[rng.randi_range(0, 1)]
	if (oreType == 'gold'):
		oreChip1.texture = Images.goldOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.goldOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.goldOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.goldOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.goldOreChips[rng.randi_range(0, 1)]
	if (oreType == 'iron'):
		oreChip1.texture = Images.ironOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.ironOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.ironOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.ironOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.ironOreChips[rng.randi_range(0, 1)]
	if (oreType == 'beige stone'):
		oreChip1.texture = Images.stoneOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.stoneOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.stoneOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.stoneOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.stoneOreChips[rng.randi_range(0, 1)]
	if (oreType == 'grey stone'):
		oreChip1.texture = Images.cobblestoneOreChips[rng.randi_range(0, 1)]
		oreChip2.texture = Images.cobblestoneOreChips[rng.randi_range(0, 1)]
		oreChip3.texture = Images.cobblestoneOreChips[rng.randi_range(0, 1)]
		oreChip4.texture = Images.cobblestoneOreChips[rng.randi_range(0, 1)]
		oreChip5.texture = Images.cobblestoneOreChips[rng.randi_range(0, 1)]
