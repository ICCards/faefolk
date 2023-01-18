extends Node2D

onready var leaf1Sprite = $Leaves/Leaf1
onready var leaf2Sprite = $Leaves/Leaf2
onready var leaf3Sprite = $Leaves/Leaf3
onready var leaf4Sprite = $Leaves/Leaf4
onready var leaf5Sprite = $Leaves/Leaf5
onready var leaf6Sprite = $Leaves/Leaf6
onready var leaf7Sprite = $Leaves/Leaf7
onready var leaf8Sprite = $Leaves/Leaf8
onready var leaf9Sprite = $Leaves/Leaf9
onready var leaf10Sprite = $Leaves/Leaf10
onready var animation_player = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var variety

	
func _ready():
	randomizeDisplayedLeaves()
	setRandomTexture()
	animation_player.play("leaves falling effect")
	yield(animation_player, "animation_finished")
	queue_free()
	
	
var randomArray = [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
func randomizeDisplayedLeaves():
	rng.randomize()
	randomArray.shuffle()
	leaf1Sprite.visible = randomArray[0] == 1
	leaf2Sprite.visible = randomArray[1] == 1
	leaf3Sprite.visible = randomArray[2] == 1
	leaf4Sprite.visible = randomArray[3] == 1
	leaf5Sprite.visible = randomArray[4] == 1
	leaf6Sprite.visible = randomArray[5] == 1
	leaf7Sprite.visible = randomArray[6] == 1
	leaf8Sprite.visible = randomArray[7] == 1
	leaf9Sprite.visible = randomArray[8] == 1
	leaf10Sprite.visible = randomArray[9] == 1
	

func setRandomTexture():
	leaf1Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf2Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf3Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf4Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf5Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf6Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf7Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf8Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf9Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	leaf10Sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	
	rng.randomize()
	leaf1Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf2Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf3Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf4Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf5Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf6Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf7Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf8Sprite.set_frame(rng.randi_range(0 , 11))
	rng.randomize()
	leaf9Sprite.set_frame(rng.randi_range(0 , 11))
