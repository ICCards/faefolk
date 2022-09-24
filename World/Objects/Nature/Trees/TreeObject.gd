extends Node2D

onready var tree_animation_player = $TreeAnimationPlayer 
onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var treeBottomSprite = $TreeSprites/TreeBottom
onready var treeTopSprite = $TreeSprites/TreeTop

onready var Bird = preload("res://World/Animals/BirdFlyingFromTree.tscn")
onready var LeavesFallEffect = preload("res://World/Objects/Nature/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()

var treeObject
var loc
var variety
var hit_dir
var health
var adjusted_leaves_falling_pos 
var biome
var tree_fallen = false
var tree_broke = false

func initialize(inputVar, _loc):
	variety = inputVar
	treeObject = Images.returnTreeObject(inputVar)
	loc = _loc

func _ready():
	setTexture(treeObject)
	set_random_leaves_falling()
	if health <= 3:
		timer.stop()
		disable_tree_top_collision_box()
		$TreeSprites/TreeTop.visible = false
		$TreeSprites/TreeBottom.visible = false
		$TreeS/stumpHurtBox.disabled = false

func setTexture(tree):
	set_tree_top_collision_shape()
	treeStumpSprite.texture = tree.stump
	treeBottomSprite.texture = tree.bottomTree
	$TreeChipParticles.texture = tree.chip 
	$TreeLeavesParticles.texture = tree.leaves
	match biome:
		"forest":
			treeTopSprite.texture = tree.topTree
		"snow":
			treeTopSprite.texture = tree.topTreeWinter
	
onready var timer = $Timer
func set_random_leaves_falling():
	rng.randomize()
	var randomDelay = rng.randi_range(1, 80)
	timer.wait_time = randomDelay
	timer.start()
	yield(timer, "timeout")
	initiateLeavesFallingEffect(treeObject)
	set_random_leaves_falling()


func PlayEffect(player_id):
	health -= 1
	if get_node("/root/World/Players/" + str(player_id) + "/" +  str(player_id)).get_position().x < get_position().x:
		hit_dir = "right"
	else:
		hit_dir = "left"
	if health >= 5:
		initiateLeavesFallingEffect(treeObject)
		$SoundEffectsTree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsTree.play()
		if hit_dir == "right":
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			tree_animation_player.play("tree hit right")
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			tree_animation_player.play("tree hit left")
	elif health == 3:
		$SoundEffectsStump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsStump.play()
		$SoundEffectsTree.stream = Sounds.tree_break
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsTree.play()
		if hit_dir == "right":
			tree_animation_player.play("tree fall right")
		else:
			tree_animation_player.play("tree fall left")
	elif health >= 1:
		$SoundEffectsTree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsTree.play()
		if hit_dir == "right":
			stump_animation_player.play("stump hit right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
		else:
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump hit right")
	else:
		Tiles.reset_valid_tiles(loc, "tree")
		$SoundEffectsStump.stream = Sounds.stump_break
		$SoundEffectsStump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsStump.play()
		stump_animation_player.play("stump destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-8, 32))
		yield(stump_animation_player, "animation_finished")
		queue_free()


### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	if health == 100:
		initiateBirdEffect()
	deduct_health(_area.tool_name)
	if health >= 40:
		initiateLeavesFallingEffect(treeObject)
		$SoundEffectsTree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsTree.play()
		
		if get_node("/root/World/Players/" + str(Server.player_id) + "/" +  str(Server.player_id)).get_position().x <= get_position().x:	
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			tree_animation_player.play("tree hit right")
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			tree_animation_player.play("tree hit left")
	elif not tree_fallen:
		tree_fallen = true
		timer.stop()
		disable_tree_top_collision_box()
		$SoundEffectsStump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsStump.play()
		$SoundEffectsTree.stream = Sounds.tree_break
		$SoundEffectsTree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsTree.play()
		if get_node("/root/World/Players/" + str(Server.player_id) + "/" +  str(Server.player_id)).get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("wood", Vector2(130, -8), 7)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("wood", Vector2(-130, -8), 7)


	elif health >= 1:
		$SoundEffectsStump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffectsStump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsStump.play()
		if get_node("/root/World/Players/" + str(Server.player_id) + "/" +  str(Server.player_id)).get_position().x <= get_position().x:
			stump_animation_player.play("stump hit right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump hit right")
	elif health <= 0 and not tree_broke: 
		tree_broke = true
		Tiles.reset_valid_tiles(loc, "tree")
		$SoundEffectsStump.stream = Sounds.stump_break
		$SoundEffectsStump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffectsStump.play()
		stump_animation_player.play("stump destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-8, 32))
		intitiateItemDrop("wood", Vector2(0, 12), 3)
		yield($SoundEffectsStump, "finished")
		queue_free()
	


func deduct_health(tool_name):
	match tool_name:
		"punch":
			health -= Stats.PUNCH_DAMAGE
		"wood axe":
			health -= Stats.WOOD_TOOL_DAMAGE
		"stone axe":
			health -= Stats.STONE_TOOL_DAMAGE
		"bronze axe":
			health -= Stats.BRONZE_TOOL_DAMAGE
		"iron axe":
			health -= Stats.IRON_TOOL_DAMAGE
		"gold axe":
			health -= Stats.GOLD_TOOL_DAMAGE


### Effect functions		
func initiateLeavesFallingEffect(tree):
	if tree == Images.D_tree:
		adjusted_leaves_falling_pos = Vector2(0, 50)
	elif tree == Images.B_tree:
		adjusted_leaves_falling_pos = Vector2(0, 25)
	else: 
		adjusted_leaves_falling_pos = Vector2(0, 0)
	var leavesEffect = LeavesFallEffect.instance()
	leavesEffect.initLeavesEffect(tree)
	add_child(leavesEffect)
	leavesEffect.global_position = global_position + adjusted_leaves_falling_pos
		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos
	
func intitiateItemDrop(item, pos, amt):
	for _i in range(amt):
		rng.randomize()
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item, 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)
	
func initiateBirdEffect():
	if Util.chance(33):
		if Util.chance(50):
			rng.randomize()
			var bird = Bird.instance()
			bird.fly_position = position + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
			get_parent().call_deferred("add_child", bird)
			bird.global_position = global_position + Vector2(0, -120)
		else:
			for i in range(2):
				rng.randomize()
				var bird = Bird.instance()
				bird.fly_position = position + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
				get_parent().call_deferred("add_child", bird)
				bird.global_position = global_position + Vector2(0, -120)
			
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
		$TreeTopArea/A.set_deferred("disabled", true)
	elif variety == "B":
		$TreeTopArea/B.set_deferred("disabled", true)
	elif variety == "C":
		$TreeTopArea/C.set_deferred("disabled", true)
	elif variety == "D":
		$TreeTopArea/D.set_deferred("disabled", true)
	elif variety == "E":
		$TreeTopArea/E.set_deferred("disabled", true)

onready var tween = $TreeSprites/Tween
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

func _on_TreeTopArea_area_entered(_area):
	set_tree_transparent()

func _on_TreeTopArea_area_exited(_area):
	set_tree_visible()

func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
