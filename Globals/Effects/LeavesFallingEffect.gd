extends Node2D

onready var leaf1Sprite = $Leaves/Leaf1
onready var leaf2Sprite = $Leaves/Leaf2
onready var leaf3Sprite = $Leaves/Leaf3
onready var leaf4Sprite = $Leaves/Leaf4
onready var leaf5Sprite = $Leaves/Leaf5
onready var leaf6Sprite = $Leaves/Leaf5

onready var AnimPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()
onready var x: int = 0
var treeType

func initLeavesEffect(treeTypeInput):
	treeType = treeTypeInput
	
func _ready():
	rng.randomize()
	randomizeDisplayedSprites()
	setTexture()
	AnimPlayer.play("leaves falling effect")
	yield(AnimPlayer, "animation_finished")
	queue_free()
	
	
var randomArray = [1, 1, 1, 0, 0, 0, 0, 0]
func randomizeDisplayedSprites():
	rng.randomize()
	randomArray.shuffle()
	leaf1Sprite.visible = randomArray[0] == 1
	leaf2Sprite.visible = randomArray[1] == 1
	leaf3Sprite.visible = randomArray[2] == 1
	leaf4Sprite.visible = randomArray[3] == 1
	leaf5Sprite.visible = randomArray[4] == 1
	leaf6Sprite.visible = randomArray[5] == 1
	

func setTexture():
	if treeType == 'A':
		leaf1Sprite.texture = Images.leaf_spritesA
		leaf1Sprite.set_frame(rng.randi_range(0 , 19))
		leaf2Sprite.texture = Images.leaf_spritesA
		leaf2Sprite.set_frame(rng.randi_range(0 , 19))
		leaf3Sprite.texture = Images.leaf_spritesA
		leaf3Sprite.set_frame(rng.randi_range(0 , 19))
		leaf4Sprite.texture = Images.leaf_spritesA
		leaf4Sprite.set_frame(rng.randi_range(0 , 19))
		leaf5Sprite.texture = Images.leaf_spritesA
		leaf5Sprite.set_frame(rng.randi_range(0 , 19))
		leaf6Sprite.texture = Images.leaf_spritesA
		leaf6Sprite.set_frame(rng.randi_range(0 , 19))
	if treeType == 'B':
		pass
	if treeType == 'C':
		pass
	if treeType == 'D':
		pass
