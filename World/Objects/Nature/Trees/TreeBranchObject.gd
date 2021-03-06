extends Node2D

onready var branch = $Branch

onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()
onready var valid_tiles = get_node("/root/World/GeneratedTiles/ValidTiles")

var randomNum
var treeObject
var loc
var health

func initialize(variety, _loc):
	randomNum = variety
	loc = _loc

func _ready():
	setTreeBranchType(randomNum)
	
func PlayEffect(player_id):
	$SoundEffects.stream = Sounds.stump_break
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
	reset_cells()
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func setTreeBranchType(num):
	if num <= 2:
		treeObject = Images.returnTreeObject('D')
	elif num <= 5:
		treeObject = Images.returnTreeObject('B')
	elif num <= 8:
		treeObject = Images.returnTreeObject('A')
	else:
		treeObject = Images.returnTreeObject('C')
	$Branch.texture = Images.tree_branch_objects[num]

func _on_BranchHurtBox_area_entered(_area):
	var data = {"id": name, "n": "log"}
	Server.action("ON_HIT", data)
	$SoundEffects.stream = Sounds.stump_break
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
	intitiateItemDrop("wood", Vector2(0, 0))
	reset_cells()
	yield($SoundEffects, "finished")
	queue_free()

func reset_cells():
	valid_tiles.set_cellv(loc, 0)


### Effect functions		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos 
	
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item, 1)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos
