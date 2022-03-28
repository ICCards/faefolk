extends Node2D

onready var tree_animation_player = $TreeAnimationPlayer 
onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeTopSprite = $TreeSprites/TreeTop
onready var treeBreakPatricles = $TreeBreak

onready var LeavesFallEffect = preload("res://Globals/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/World/YSort/Player")
var rng = RandomNumberGenerator.new()
onready var world = get_tree().current_scene

onready var treeTypes = ['A','B', 'C', 'D', 'E']
var treeObject
func _ready():
	randomize()
	treeTypes.shuffle()
	treeObject = Images.returnFruitlessTreeObject(treeTypes[0])
	setTexture(treeObject)

func setTexture(tree):
	treeBreakPatricles.texture = tree.leaves
	treeStumpSprite.texture = tree.stump
	treeTopSprite.texture = tree.topTree
	treeBottomSprite.texture = tree.bottomTree
		

var treeHealth: int = 4
func _on_Hurtbox_area_entered(area):
	if treeHealth == 0:
		if Player.get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			var itemDrop = ItemDrop.instance()
			itemDrop.initItemDropType("Wood")
			world.add_child(itemDrop)
			itemDrop.global_position = global_position + Vector2(130, -8)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			var itemDrop = ItemDrop.instance()
			itemDrop.initItemDropType("Wood")
			world.add_child(itemDrop)
			itemDrop.global_position = global_position + Vector2(-130, -8)


	elif treeHealth != 0:
		var leavesEffect = LeavesFallEffect.instance()
		leavesEffect.initLeavesEffect(treeObject)
		world.add_child(leavesEffect)
		if treeTypes[0] == 'D' || treeTypes[0] == 'E':
			leavesEffect.global_position = global_position + Vector2(0, 50)
		else: 
			leavesEffect.global_position = global_position
		
		if Player.get_position().x <= get_position().x:
			var trunkHitEffect = TrunkHitEffect.instance()
			trunkHitEffect.init(treeObject, "tree hit right")
			world.add_child(trunkHitEffect)
			trunkHitEffect.global_position = global_position + Vector2(15, 20)
			tree_animation_player.play("tree hit right")
			treeHealth = treeHealth - 1
		else: 
			var trunkHitEffect = TrunkHitEffect.instance()
			trunkHitEffect.init(treeObject, "tree hit left")
			world.add_child(trunkHitEffect) 
			trunkHitEffect.global_position = global_position + Vector2(-15, 20)
			tree_animation_player.play("tree hit left") 
			treeHealth = treeHealth - 1

var stumpHealth: int = 2
func _on_stumpHurtBox_area_entered(area):
	if stumpHealth == 0: 
		stump_animation_player.play("stump_destroyed")
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType("Wood")
		world.call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + Vector2(0, 24)

	elif stumpHealth != 0 :
		if Player.get_position().x <= get_position().x:
			stump_animation_player.play("stump_hit_right")
			var trunkHitEffect = TrunkHitEffect.instance()
			trunkHitEffect.init(treeObject, "tree hit right")
			world.add_child(trunkHitEffect)
			trunkHitEffect.global_position = global_position + Vector2(15, 20)
			stumpHealth = stumpHealth - 1
		else: 
			stump_animation_player.play("stump_hit_right")
			var trunkHitEffect = TrunkHitEffect.instance()
			trunkHitEffect.init(treeObject, "tree hit left")
			world.add_child(trunkHitEffect)
			trunkHitEffect.global_position = global_position + Vector2(-15, 20)
			stumpHealth = stumpHealth - 1
