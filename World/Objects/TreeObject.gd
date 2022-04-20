extends Node2D

onready var tree_animation_player = $TreeAnimationPlayer 
onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeTopSprite = $TreeSprites/TreeTop
onready var treeBreakPatricles = $TreeBreak
onready var treeBreakPatricles2 = $TreeBreak2

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
	treeBreakPatricles.texture = tree.leaves
	treeBreakPatricles2.texture = tree.chip
	treeStumpSprite.texture = tree.stump
	treeTopSprite.texture = tree.topTree
	treeBottomSprite.texture = tree.bottomTree
		

var treeHealth: int = 4
func _on_Hurtbox_area_entered(_area):
	if treeHealth == 0:
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
		$SoundEffectsTree.stream = Global.tree_break
		$SoundEffectsTree.play()
		if Player.get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", 130, -8)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", -130, -8)

	elif treeHealth != 0:
		$SoundEffectsTree.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.play()
		if treeTypes[0] == 'D' || treeTypes[0] == 'E':
			initiateLeavesFallingEffect(treeObject, 0, 50)
		elif treeTypes[0] == 'B':
			initiateLeavesFallingEffect(treeObject, 0, 25)
		else: 
			initiateLeavesFallingEffect(treeObject, 0, 0)

		if Player.get_position().x <= get_position().x:	
			initiateTreeHitEffect(treeObject, "tree hit right", 15, 20)
			tree_animation_player.play("tree hit right")
			treeHealth = treeHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", -15, 20)
			tree_animation_player.play("tree hit left")
			treeHealth = treeHealth - 1

var stumpHealth: int = 2
func _on_stumpHurtBox_area_entered(_area):
	if stumpHealth == 0: 
		$SoundEffectsStump.stream = Global.stump_break
		$SoundEffectsStump.play()
		stump_animation_player.play("stump_destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", 0, 64)
		intitiateItemDrop("Wood", 0, 24)
		yield($SoundEffectsStump, "finished")
		queue_free()
	
	elif stumpHealth != 0 :
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
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

