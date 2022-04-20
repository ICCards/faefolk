extends Node2D

onready var branch = $Branch

onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/World/YSort/Player")
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene

var randomNum
var treeObject

func _ready():
	rng.randomize()
	randomNum = rng.randi_range(0, 11)
	branch.texture = Images.tree_branch_objects[randomNum]
	setTreeBranchType(randomNum)

func setTreeBranchType(num):
	if num <= 2:
		treeObject = Images.returnTreeObject('A')
	elif num <= 5:
		treeObject = Images.returnTreeObject('B')
	elif num <= 8:
		treeObject = Images.returnTreeObject('C')
	else:
		treeObject = Images.returnTreeObject('D')

func _on_BranchHurtBox_area_entered(area):
	$SoundEffects.stream = Global.stump_break
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", 0, 50)
	intitiateItemDrop("Wood", 0, 0)
	yield($SoundEffects, "finished")
	queue_free()


### Effect functions		
		
func initiateTreeHitEffect(tree, effect, positionX, positionY):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	world.add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + Vector2(positionX, positionY)
	
func intitiateItemDrop(item, positionX, positionY):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item)
	world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + Vector2(positionX, positionY)
