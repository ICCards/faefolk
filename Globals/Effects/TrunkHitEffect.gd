extends Node2D

onready var treeChip1Sprite = $TreeChips/TreeChip1
onready var treeChip2Sprite = $TreeChips/TreeChip2
onready var treeChip3Sprite = $TreeChips/TreeChip3
onready var treeChip4Sprite = $TreeChips/TreeChip4
onready var treeChip5Sprite = $TreeChips/TreeChip5

onready var AnimPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var treeObject
var effectType

func init(treeTypeInput, effectTypeInput):
	treeObject = treeTypeInput
	effectType = effectTypeInput


func _ready():
	rng.randomize()
	randomizeDisplayedSprites()
	setTexture(treeObject)
	if effectType == "tree hit right": 
		AnimPlayer.play("tree hit right")
	if effectType == "tree hit left":
		AnimPlayer.play("tree hit left")
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
	
func setTexture(tree):
	treeChip1Sprite.texture = tree.chip
	treeChip2Sprite.texture = tree.chip
	treeChip3Sprite.texture = tree.chip
	treeChip4Sprite.texture = tree.chip
	treeChip5Sprite.texture = tree.chip
	
