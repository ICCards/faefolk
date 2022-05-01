extends Node2D

onready var tree_animation_player = $TreeAnimationPlayer 
onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeTopSprite = $TreeSprites/TreeTop

onready var LeavesFallEffect = preload("res://Globals/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://Globals/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/PlayerHomeFarm/Player")
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
	set_random_leaves_falling()
	if !showFullTree:
		timer.stop()
		disable_tree_top_collision_box()
		$TreeHurtbox/treeHurtBox.disabled = true
		$TreeSprites/TreeTop.visible = false
		$TreeSprites/TreeBottom.visible = false
		$StumpHurtBox/stumpHurtBox.disabled = false

func setTexture(tree):
	set_tree_top_collision_shape()
	treeStumpSprite.texture = tree.stump
	treeTopSprite.texture = tree.topTree
	treeBottomSprite.texture = tree.bottomTree
	$TreeChipParticles.texture = tree.chip 
	$TreeLeavesParticles.texture = tree.leaves
	
onready var timer = $Timer
func set_random_leaves_falling():
	rng.randomize()
	var randomDelay = rng.randi_range(1, 80)
	timer.wait_time = randomDelay
	timer.start()
	yield(timer, "timeout")
	if variety == 'D' || variety == 'E':
		initiateLeavesFallingEffect(treeObject, Vector2(0, 50))
	elif variety == 'B':
		initiateLeavesFallingEffect(treeObject, Vector2(0, 25))
	else: 
		initiateLeavesFallingEffect(treeObject, Vector2(0, 0))
	set_random_leaves_falling()


### Tree hurtbox
var treeHealth: int = 4
func _on_Hurtbox_area_entered(_area):
	if treeHealth == 0:
		timer.stop()
		disable_tree_top_collision_box()
		PlayerInventory.set_farm_object_break(pos)
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
		$SoundEffectsTree.stream = Global.tree_break
		$SoundEffectsTree.play()
		if Player.get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", Vector2(130, -8), 7)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("Wood", Vector2(-130, -8), 7)

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
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			tree_animation_player.play("tree hit right")
			treeHealth = treeHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			tree_animation_player.play("tree hit left")
			treeHealth = treeHealth - 1

### Stump hurtbox
var stumpHealth: int = 2
func _on_stumpHurtBox_area_entered(_area):
	if stumpHealth == 0: 
		$SoundEffectsStump.stream = Global.stump_break
		$SoundEffectsStump.play()
		stump_animation_player.play("stump_destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-8, 32))
		intitiateItemDrop("Wood", Vector2(0, 12), 3)
		PlayerInventory.remove_farm_object(pos)
		yield($SoundEffectsStump, "finished")
		queue_free()
	
	elif stumpHealth != 0 :
		$SoundEffectsStump.stream = Global.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.play()
		if Player.get_position().x <= get_position().x:
			stump_animation_player.play("stump_hit_right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			stumpHealth = stumpHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump_hit_right")
			stumpHealth = stumpHealth - 1


### Effect functions		
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
	
func intitiateItemDrop(item, pos, amt):
	for i in range(amt):
		rng.randomize()
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item)
		world.call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)
	


### Tree modulate functions
func set_tree_top_collision_shape():
	if variety == "A":
		$TreeTopArea/A.disabled = false
	elif variety == "B":
		$TreeTopArea/B.disabled = false
	elif variety == "C":
		$TreeTopArea/C.disabled = false
	elif variety == "D":
		$TreeTopArea/D.disabled = false
	elif variety == "E":
		$TreeTopArea/E.disabled = false

func disable_tree_top_collision_box():
	set_tree_visible()
	if variety == "A":
		$TreeTopArea/A.call_deferred("set", "disabled", true)
	elif variety == "B":
		$TreeTopArea/B.call_deferred("set", "disabled", true)
	elif variety == "C":
		$TreeTopArea/C.call_deferred("set", "disabled", true)
	elif variety == "D":
		$TreeTopArea/D.call_deferred("set", "disabled", true)
	elif variety == "E":
		$TreeTopArea/E.call_deferred("set", "disabled", true)

onready var tween = $Tween
func set_tree_transparent():
	tween.interpolate_property($TreeSprites/TreeTop, "modulate",
		$TreeSprites/TreeTop.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween.interpolate_property($TreeSprites/TreeStump, "modulate",
		$TreeSprites/TreeStump.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween.interpolate_property($TreeSprites/TreeBottom, "modulate",
		$TreeSprites/TreeBottom.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	
func set_tree_visible():
	tween.interpolate_property($TreeSprites/TreeTop, "modulate",
		$TreeSprites/TreeTop.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween.interpolate_property($TreeSprites/TreeStump, "modulate",
		$TreeSprites/TreeStump.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	tween.interpolate_property($TreeSprites/TreeBottom, "modulate",
		$TreeSprites/TreeBottom.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_TreeTopArea_area_entered(area):
	set_tree_transparent()

func _on_TreeTopArea_area_exited(area):
	set_tree_visible()

