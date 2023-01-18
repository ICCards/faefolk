extends Node2D

onready var treeChip1Sprite = $TreeChips/TreeChip1
onready var treeChip2Sprite = $TreeChips/TreeChip2
onready var treeChip3Sprite = $TreeChips/TreeChip3
onready var treeChip4Sprite = $TreeChips/TreeChip4
onready var treeChip5Sprite = $TreeChips/TreeChip5
onready var treeChip6Sprite = $TreeChips/TreeChip6

onready var animation_player = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var treeObject
var effectType
var variety

func init(_variety, effectTypeInput):
	variety = _variety
	effectType = effectTypeInput


func _ready():
	setTexture(treeObject)
	if effectType == "tree hit right": 
		randomizeDisplayedSprites()
		animation_player.play("tree hit right")
	elif effectType == "tree hit left":
		randomizeDisplayedSprites()
		animation_player.play("tree hit left")
	elif effectType == "trunk break":
		animation_player.play("trunk break")
	yield(animation_player, "animation_finished")
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
	treeChip6Sprite.visible = false
	
func setTexture(tree):
	treeChip1Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	treeChip2Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	treeChip3Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	treeChip4Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	treeChip5Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	treeChip6Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	
