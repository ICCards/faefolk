extends Node2D

onready var tree_animation_player = $TreeAnimationPlayer 
onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeTopSprite = $TreeSprites/TreeTop

onready var LeavesFallEffect = preload("res://Globals/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var TreeExplosionEffect = preload("res://Globals/Effects/TreeExplosionEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/World/Farm/Player")
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene

var treeObject
var pos
var variety
var showFullTree

func initialize(inputVar, inputPos, ifFullTree):
	variety = inputVar
	treeObject = Images.returnTreeObject(inputVar)
	pos = inputPos
	showFullTree = ifFullTree

func _ready():
	setTexture(treeObject)

func setTexture(tree):
	treeStumpSprite.texture = tree.stump
	treeTopSprite.texture = tree.topTree
	treeBottomSprite.texture = tree.bottomTree
	$TreeChipParticles.texture = tree.chip 
	$TreeLeavesParticles.texture = tree.leaves
	if !showFullTree:
		$TreeHurtbox/treeHurtBox.disabled = true
		$TreeSprites/TreeTop.visible = false
		$StumpHurtBox/stumpHurtBox.disabled = false
		

var treeHealth: int = 4
func _on_Hurtbox_area_entered(_area):
	if treeHealth == 0:
		PlayerInventory.set_farm_object_break(pos)
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
		$SoundEffectsTree.stream = Global.tree_break
		$SoundEffectsTree.play()
		if Player.get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", Vector2(130, -8))
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", Vector2(-130, -8))

	elif treeHealth != 0:
		$SoundEffectsTree.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.play()
		if variety == 'D' || variety == 'E':
			initiateLeavesFallingEffect(treeObject, Vector2(0, 50))
		elif variety == 'B':
			initiateLeavesFallingEffect(treeObject, Vector2(0, 25))
		else: 
			initiateLeavesFallingEffect(treeObject, Vector2(0, 0))

		if Player.get_position().x <= get_position().x:	
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 25))
			tree_animation_player.play("tree hit right")
			treeHealth = treeHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 25))
			tree_animation_player.play("tree hit left")
			treeHealth = treeHealth - 1

var stumpHealth: int = 2
func _on_stumpHurtBox_area_entered(_area):
	if stumpHealth == 0: 
		$SoundEffectsStump.stream = Global.stump_break
		$SoundEffectsStump.play()
		stump_animation_player.play("stump_destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-8, 32))
		intitiateItemDrop("Wood", Vector2(0, 24))
		PlayerInventory.remove_farm_object(pos)
		yield($SoundEffectsStump, "finished")
		queue_free()
	
	elif stumpHealth != 0 :
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
		if Player.get_position().x <= get_position().x:
			stump_animation_player.play("stump_hit_right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 25))
			stumpHealth = stumpHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 25))
			stump_animation_player.play("stump_hit_right")
			stumpHealth = stumpHealth - 1
			
		
### Effect functions		
func initiateTreeExplosionEffect(tree, pos):
	for i in range(12):
		rng.randomize()
		var treeExplosionEffect = TreeExplosionEffect.instance()
		treeExplosionEffect.init(tree)
		world.call_deferred("add_child", treeExplosionEffect) 
		treeExplosionEffect.global_position = global_position + pos + Vector2(rng.randi_range(-80, 80), rng.randi_range(-8, 8))

func initiateLeavesFallingEffect(tree, pos):
	var leavesEffect = LeavesFallEffect.instance()
	leavesEffect.initLeavesEffect(tree)
	add_child(leavesEffect)
	leavesEffect.global_position = global_position + pos
		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos
	
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item)
	world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos

