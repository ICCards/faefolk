extends Node2D

onready var tree_stump_sprite: Sprite = $TreeSprites/TreeStump
onready var tree_bottom_sprite: Sprite = $TreeSprites/TreeBottom
onready var tree_top_sprite: Sprite = $TreeSprites/TreeTop
onready var sound_effects_stump: AudioStreamPlayer2D = $SoundEffectsStump
onready var sound_effects_tree: AudioStreamPlayer2D = $SoundEffectsTree
onready var animation_player_tree: AnimationPlayer = $AnimationPlayerTree
onready var animation_player_stump: AnimationPlayer = $AnimationPlayerStump
onready var navigation_obstacle: NavigationObstacle2D = $NavigationObstacle2D
onready var random_leaves_falling_timer: Timer = $RandomLeavesFallingTimer
onready var tween: Tween = $TreeSprites/Tween

var rng = RandomNumberGenerator.new()

var treeObject
var location
var variety
var hit_dir
var health
var adjusted_leaves_falling_pos 
var biome
var tree_fallen = false
var tree_broke = false



func _ready():
	random_leaves_falling_timer.wait_time = rng.randi_range(15.0, 60.0)
	treeObject = Images.returnTreeObject(variety)
	setTexture(treeObject)
	### FIX THIS IF TREE ALREADY BROKE
	if health <= 3:
		disable_tree_top_collision_box()
		tree_top_sprite.hide()
		tree_bottom_sprite.hide()

func setTexture(tree):
	set_tree_top_collision_shape()
	tree_stump_sprite.texture = tree.stump
	tree_bottom_sprite.texture = tree.bottomTree
	$TreeChipParticles.texture = tree.chip 
	$TreeLeavesParticles.texture = tree.leaves
	match biome:
		"forest":
			tree_top_sprite.texture = tree.topTree
		"snow":
			tree_top_sprite.texture = tree.topTreeWinter


func PlayEffect(player_id):
	health -= 1
	if get_node("/root/World/Players/" + str(player_id) + "/" +  str(player_id)).get_position().x < get_position().x:
		hit_dir = "right"
	else:
		hit_dir = "left"
	if health >= 5:
		InstancedScenes.initiateLeavesFallingEffect(variety, position)
		sound_effects_tree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_tree.play()
		if hit_dir == "right":
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", Vector2(0, 12))
			animation_player_tree.play("tree hit right")
		else: 
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", Vector2(-24, 12))
			animation_player_tree.play("tree hit left")
	elif health == 3:
		sound_effects_stump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		sound_effects_tree.stream = Sounds.tree_break
		sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_tree.play()
		if hit_dir == "right":
			animation_player_tree.play("tree fall right")
		else:
			animation_player_tree.play("tree fall left")
	elif health >= 1:
		sound_effects_tree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_tree.play()
		if hit_dir == "right":
			animation_player_stump.play("stump hit right")
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", Vector2(0, 12))
		else:
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", Vector2(-24, 12))
			animation_player_stump.play("stump hit right")
	else:
		Tiles.set_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
		sound_effects_stump.stream = Sounds.stump_break
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		animation_player_stump.play("stump destroyed")
		InstancedScenes.initiateTreeHitEffect(variety, "trunk break", Vector2(-8, 32))
		yield(animation_player_stump, "animation_finished")
		queue_free()


### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	var data = {"id": name, "n": "tree"}
	Server.action("ON_HIT", data)
	if health == 100:
		InstancedScenes.initiateBirdEffect(position)
	health -= Stats.return_axe_damage(_area.tool_name)
	if health > 25:
		InstancedScenes.initiateLeavesFallingEffect(variety, position)
		sound_effects_tree.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_tree.play()
		if Server.player_node.get_position().x <= get_position().x:
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position+Vector2(0, 12))
			animation_player_tree.play("tree hit right")
		else: 
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position+Vector2(-24, 12))
			animation_player_tree.play("tree hit left")
	elif not tree_fallen:
		tree_fallen = true
		disable_tree_top_collision_box()
		sound_effects_stump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		sound_effects_tree.stream = Sounds.tree_break
		sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_tree.play()
		if Server.player_node.get_position().x <= get_position().x:
			animation_player_tree.play("tree fall right")
			yield(animation_player_tree, "animation_finished" )
			InstancedScenes.intitiateItemDrop("wood", position+Vector2(130, -8), Stats.return_item_drop_quantity(_area.tool_name, "tree"))
		else:
			animation_player_tree.play("tree fall left")
			yield(animation_player_tree, "animation_finished" )
			InstancedScenes.intitiateItemDrop("wood", position+Vector2(-130, -8), Stats.return_item_drop_quantity(_area.tool_name, "tree"))

	elif health >= 1:
		sound_effects_stump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		if Server.player_node.get_position().x <= get_position().x:
			animation_player_stump.play("stump hit right")
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position+Vector2(0, 12))
		else: 
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position+Vector2(-24, 12))
			animation_player_stump.play("stump hit right")
	elif health <= 0 and not tree_broke: 
		tree_broke = true
		Tiles.set_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
		sound_effects_stump.stream = Sounds.stump_break
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		animation_player_stump.play("stump destroyed")
		InstancedScenes.initiateTreeHitEffect(variety, "trunk break", position+Vector2(-8, 32))
		InstancedScenes.intitiateItemDrop("wood", position+Vector2(0, 12), Stats.return_item_drop_quantity(_area.tool_name, "stump"))
		yield(get_tree().create_timer(3.0), "timeout")
		queue_free()


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


func set_tree_transparent():
	tween.interpolate_property(tree_top_sprite, "modulate",
		tree_top_sprite.get_modulate(), Color(1, 1, 1, 0.45), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_stump_sprite, "modulate",
		tree_stump_sprite.get_modulate(), Color(1, 1, 1, 0.45), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_bottom_sprite, "modulate",
		tree_bottom_sprite.get_modulate(), Color(1, 1, 1, 0.45), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func set_tree_visible():
	tween.interpolate_property(tree_top_sprite, "modulate",
		tree_top_sprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_stump_sprite, "modulate",
		tree_stump_sprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_bottom_sprite, "modulate",
		tree_bottom_sprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
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

func _on_RandomLeavesFallingTimer_timeout():
	random_leaves_falling_timer.wait_time = rng.randi_range(15.0, 60.0)
	InstancedScenes.initiateLeavesFallingEffect(variety, position)
