extends Node2D

onready var treeChip1Sprite = $TreeChips/TreeChip1
onready var treeChip2Sprite = $TreeChips/TreeChip2
onready var treeChip3Sprite = $TreeChips/TreeChip3
onready var treeChip4Sprite = $TreeChips/TreeChip4
onready var treeChip5Sprite = $TreeChips/TreeChip5

onready var AnimPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var treeType
var effectType

func init(treeTypeInput, effectTypeInput):
	treeType = treeTypeInput
	effectType = effectTypeInput


func _ready():
	rng.randomize()
	randomizeDisplayedSprites()
	setTexture()
	if (effectType == "tree hit right"): 
		AnimPlayer.play("tree hit right")
	if (effectType == "tree hit left"):
		pass
	yield(AnimPlayer, "animation_finished")
	queue_free()

	
var randomArray = [1, 1, 1, 0, 0, 0, 0, 0]
func randomizeDisplayedSprites():
	rng.randomize()
	randomArray.shuffle()
	treeChip1Sprite.visible = randomArray[0] == 1
	treeChip2Sprite.visible = randomArray[1] == 1
	treeChip3Sprite.visible = randomArray[2] == 1
	treeChip4Sprite.visible = randomArray[3] == 1
	treeChip5Sprite.visible = randomArray[4] == 1
	
func setTexture():
	if treeType == 'A':
		treeChip1Sprite.texture = Images.chipA
		treeChip2Sprite.texture = Images.chipA
		treeChip3Sprite.texture = Images.chipA
		treeChip4Sprite.texture = Images.chipA
		treeChip5Sprite.texture = Images.chipA
	if treeType == 'B':
		treeChip1Sprite.texture = Images.chipB
		treeChip2Sprite.texture = Images.chipB
		treeChip3Sprite.texture = Images.chipB
		treeChip4Sprite.texture = Images.chipB
		treeChip5Sprite.texture = Images.chipB
	if treeType == 'C':
		treeChip1Sprite.texture = Images.chipC
		treeChip2Sprite.texture = Images.chipC
		treeChip3Sprite.texture = Images.chipC
		treeChip4Sprite.texture = Images.chipC
		treeChip5Sprite.texture = Images.chipC
	if treeType == 'D':
		treeChip1Sprite.texture = Images.chipD
		treeChip2Sprite.texture = Images.chipD
		treeChip3Sprite.texture = Images.chipD
		treeChip4Sprite.texture = Images.chipD
		treeChip5Sprite.texture = Images.chipD
	
