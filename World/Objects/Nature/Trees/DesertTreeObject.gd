extends Node2D

var rng = RandomNumberGenerator.new()
onready var tween = $Tween
onready var timer = $Timer
onready var tree_animation_player = $AnimationPlayer

var health
var treeObject
var adjusted_leaves_falling_pos

onready var LeavesFallEffect = preload("res://World/Objects/Nature/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

func _ready():
	treeObject = Images.returnRandomDesertTree()
	$AnimatedSprite.frames = Images.returnRandomDesertTree()

func _on_TreeHurtbox_area_entered(area):
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	health -= 1
	if health >= 4:
		initiateLeavesFallingEffect(treeObject)
		$SoundEffects.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		
		if get_node("/root/World/Players/" + str(Server.player_id)).get_position().x <= get_position().x:	
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			tree_animation_player.play("tree hit right")
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			tree_animation_player.play("tree hit left")
	elif health == 3:
		timer.stop()
		disable_tree_top_collision_box()
		$SoundEffects.stream = Sounds.tree_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		if get_node("/root/World/Players/" + str(Server.player_id)).get_position().x <= get_position().x:
			tree_animation_player.play("tree fall right")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("wood", Vector2(130, -8), 7)
		else:
			tree_animation_player.play("tree fall left")
			yield(tree_animation_player, "animation_finished" )
			intitiateItemDrop("wood", Vector2(-130, -8), 7)
		queue_free()
			
			
func disable_tree_top_collision_box():
	set_tree_visible()
	$TreeTopArea/CollisionPolygon2D.set_deferred("disabled", true)

			
### Effect functions		
func initiateLeavesFallingEffect(tree):
	pass
#	if tree == Images.D_tree:
#		adjusted_leaves_falling_pos = Vector2(0, 50)
#	elif tree == Images.B_tree:
#		adjusted_leaves_falling_pos = Vector2(0, 25)
#	else: 
#		adjusted_leaves_falling_pos = Vector2(0, 0)
#	var leavesEffect = LeavesFallEffect.instance()
#	leavesEffect.initLeavesEffect(tree)
#	add_child(leavesEffect)
#	leavesEffect.global_position = global_position + adjusted_leaves_falling_pos
		
func initiateTreeHitEffect(tree, effect, pos):
	pass
#	var trunkHitEffect = TrunkHitEffect.instance()
#	trunkHitEffect.init(tree, effect)
#	add_child(trunkHitEffect)
#	trunkHitEffect.global_position = global_position + pos
	
func intitiateItemDrop(item, pos, amt):
	for _i in range(amt):
		rng.randomize()
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item, 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)


func set_tree_visible():
	tween.interpolate_property($AnimatedSprite, "modulate",
		$AnimatedSprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func set_tree_transparent():
	tween.interpolate_property($AnimatedSprite, "modulate",
		$AnimatedSprite.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_TreeTopArea_area_entered(area):
	set_tree_transparent()
func _on_TreeTopArea_area_exited(area):
	set_tree_visible()
