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
		treeObject = Images.returnTreeObject('D')
	else:
		treeObject = Images.returnTreeObject('C')

func _on_BranchHurtBox_area_entered(area):
	$SoundEffects.stream = Global.stump_break
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 50))
	intitiateItemDrop("Wood", Vector2(0, 0))
	yield($SoundEffects, "finished")
	queue_free()


### Effect functions		
		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	world.add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos
	
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item)
	world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos
