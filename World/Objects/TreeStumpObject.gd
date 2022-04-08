extends Node2D

onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump

onready var LeavesFallEffect = preload("res://Globals/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/World/YSort/Player")
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene
onready var treeTypes = ['A','B', 'C', 'D', 'E']
var treeObject

func _ready():
	rng.randomize()
	treeTypes.shuffle()
	treeObject = Images.returnTreeObject(treeTypes[0])
	setTexture(treeObject)

func setTexture(tree):
	treeStumpSprite.texture = tree.largeStump




var stumpHealth: int = 2
func _on_StumpHurtBox_area_entered(area):
	if stumpHealth == 0: 
		stump_animation_player.play("stump_destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", 0, 64)
		intitiateItemDrop("Wood", 0, 24)
	
	elif stumpHealth != 0 :
		if Player.get_position().x <= get_position().x:
			stump_animation_player.play("stump_hit_right")
			initiateTreeHitEffect(treeObject, "tree hit right", 15, 20)
			stumpHealth = stumpHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", -15, 20)
			stump_animation_player.play("stump_hit_right")
			stumpHealth = stumpHealth - 1
			

### Effect functions		
func initiateLeavesFallingEffect(tree, positionX, positionY):
	var leavesEffect = LeavesFallEffect.instance()
	leavesEffect.initLeavesEffect(tree)
	world.add_child(leavesEffect)
	leavesEffect.global_position = global_position + Vector2(positionX, positionY)
		
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


