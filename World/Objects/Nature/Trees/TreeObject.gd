extends Node2D

onready var tree_stump_sprite: Sprite = $TreeSprites/TreeStump
onready var tree_bottom_sprite: Sprite = $TreeSprites/TreeBottom
onready var tree_top_sprite: Sprite = $TreeSprites/TreeTop
onready var animated_tree_top_sprite: AnimatedSprite = $TreeSprites/AnimatedTop
onready var sound_effects_stump: AudioStreamPlayer2D = $SoundEffectsStump
onready var sound_effects_tree: AudioStreamPlayer2D = $SoundEffectsTree
onready var animation_player_tree: AnimationPlayer = $AnimationPlayerTree
onready var animation_player_stump: AnimationPlayer = $AnimationPlayerStump
onready var random_leaves_falling_timer: Timer = $RandomLeavesFallingTimer
onready var tween: Tween = $TreeSprites/Tween

var rng = RandomNumberGenerator.new()

var location
var variety
var hit_dir
var health
var adjusted_leaves_falling_pos 
var biome
var tree_fallen = false
var destroyed = false

var phase

var temp_health: int = 3

func _ready():
	hide()
	rng.randomize()
	MapData.connect("refresh_crops", self, "refresh_tree_type")
	set_tree()

func set_tree():
	phase = str(phase)
	if phase == "5" and Util.isNonFruitTree(MapData.world["tree"][name]["v"]): # grown nonfruit tree
		animated_tree_top_sprite.show()
		tree_bottom_sprite.show()
		tree_stump_sprite.show()
		tree_top_sprite.hide()
		$TreeSprites/TreeSapling.hide()
		setGrownTreeTexture()
	elif phase == "mature1" or phase == "mature2" or phase == "harvest" or phase == "empty" and Util.isNonFruitTree(MapData.world["tree"][name]["v"]): # grown fruit tree
		animated_tree_top_sprite.show()
		tree_bottom_sprite.show()
		tree_stump_sprite.show()
		tree_top_sprite.show()
		$TreeSprites/TreeSapling.hide()
		setGrownTreeTexture()
	else:
		animated_tree_top_sprite.hide()
		tree_bottom_sprite.hide()
		tree_stump_sprite.hide()
		tree_top_sprite.hide()
		$TreeSprites/TreeSapling.show()
		$TreeSprites/TreeSapling.texture = load("res://Assets/Images/tree_sets/"+ variety +"/growing/"+ phase +".png")


func refresh_tree_type():
	if MapData.world["tree"].has(name):
		if phase != "5" and Util.isNonFruitTree(MapData.world["tree"][name]["v"]):
			phase = MapData.world["tree"][name]["p"]
			set_tree()
		elif phase != "harvest" and Util.isFruitTree(MapData.world["tree"][name]["v"]):
			phase = MapData.world["tree"][name]["p"]
			set_tree()


func setGrownTreeTexture():
	random_leaves_falling_timer.wait_time = rng.randi_range(15.0, 60.0)
	if health < Stats.STUMP_HEALTH:
		tree_fallen = true
		disable_tree_top_collision_box()
		animated_tree_top_sprite.hide()
		tree_bottom_sprite.hide()
	set_tree_top_collision_shape()
	tree_stump_sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/mature/stump.png")
	tree_bottom_sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/mature/bottom.png")
	$TreeChipParticles.texture = load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png")
	$TreeLeavesParticles.texture =load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png")
	animated_tree_top_sprite.frame = rng.randi_range(0,19)
	match biome:
		"forest":
			tree_top_sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/mature/top.png")
			animated_tree_top_sprite.frames = load("res://Assets/Images/tree_sets/"+ variety +"/mature/animated top.tres")
		"snow":
			tree_top_sprite.texture = load("res://Assets/Images/tree_sets/"+ variety +"/mature/top winter.png")
			animated_tree_top_sprite.frames =load("res://Assets/Images/tree_sets/"+ variety +"/mature/animated top winter.tres")
	match variety:
		"oak":
			animated_tree_top_sprite.offset = Vector2(-1,-107)
		"spruce":
			animated_tree_top_sprite.offset = Vector2(0,-102)
		"birch":
			animated_tree_top_sprite.offset = Vector2(0,-122)
		"evergreen":
			animated_tree_top_sprite.offset = Vector2(-3,-66)
		"pine":
			animated_tree_top_sprite.offset = Vector2(0,-119)

func hit(tool_name):
	if not destroyed:
		if not phase == "5":
			animation_player_stump.play("sapling hit")
			$ResetTempHealthTimer.start()
			temp_health -= 1
			sound_effects_tree.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3")
			sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
			sound_effects_tree.play()
			if temp_health <= 0 and not destroyed: 
				destroy("sapling")
		else:
			if health == 100:
				InstancedScenes.initiateBirdEffect(position)
			health -= Stats.return_tool_damage(tool_name)
			if MapData.world["tree"].has(name):
				MapData.world["tree"][name]["h"] = health
			if health >= Stats.STUMP_HEALTH:
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
				if health <= 0 and not destroyed:
					destroy(tool_name)
				tree_fallen = true
				disable_tree_top_collision_box()
				sound_effects_stump.stream = Sounds.tree_hit[rng.randi_range(0,2)]
				sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
				sound_effects_stump.play()
				sound_effects_tree.stream = Sounds.tree_break
				sound_effects_tree.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
				sound_effects_tree.play()
				if Server.player_node.get_position().x <= get_position().x:
					animation_player_tree.play("tree fall right")
					yield(animation_player_tree, "animation_finished" )
					var amt = Stats.return_item_drop_quantity(tool_name, "tree")
					PlayerData.player_data["collections"]["resources"]["wood"] += amt
					InstancedScenes.intitiateItemDrop("wood", position+Vector2(130, -8), amt)
					if Util.chance(5):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(130, -8), 3)
					elif Util.chance(15):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(130, -8), 2)
					elif Util.chance(25):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(130, -8), 1)
				
				else:
					animation_player_tree.play("tree fall left")
					yield(animation_player_tree, "animation_finished" )
					var amt = Stats.return_item_drop_quantity(tool_name, "tree")
					PlayerData.player_data["collections"]["resources"]["wood"] += amt
					InstancedScenes.intitiateItemDrop("wood", position+Vector2(-130, -8), amt)
					if Util.chance(5):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-130, -8), 3)
					elif Util.chance(15):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-130, -8), 2)
					elif Util.chance(25):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-130, -8), 1)
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
			if health <= 0 and not destroyed: 
				destroy(tool_name)


func destroy(tool_name):
	MapData.world["tree"].erase(name)
	destroyed = true
	Tiles.add_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
	InstancedScenes.initiateTreeHitEffect(variety, "trunk break", position+Vector2(-8, 32))
	if not tool_name == "sapling":
		animation_player_stump.play("stump destroyed")
		sound_effects_stump.stream = Sounds.stump_break
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects_stump.play()
		var amt = Stats.return_item_drop_quantity(tool_name, "stump")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position+Vector2(0, 12), amt)
		yield(get_tree().create_timer(3.0), "timeout")
	else:
		animation_player_stump.play("sapling destroyed")
		sound_effects_stump.stream = load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3")
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects_stump.play()
		yield(get_tree().create_timer(3.0), "timeout")
	queue_free()

### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		hit(_area.tool_name)
	if _area.special_ability == "fire buff" and phase == "5":
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-16,16), rand_range(-10,22)))
		health -= Stats.FIRE_DEBUFF_DAMAGE


### Tree modulate functions
func set_tree_top_collision_shape():
	if variety == "oak":
		$TreeTopArea/A.set_deferred("disabled", false)
	elif variety == "spruce":
		$TreeTopArea/B.set_deferred("disabled", false)
	elif variety == "birch":
		$TreeTopArea/C.set_deferred("disabled", false)
	elif variety == "evergreen":
		$TreeTopArea/D.set_deferred("disabled", false)
	elif variety == "pine":
		$TreeTopArea/E.set_deferred("disabled", false)


func disable_tree_top_collision_box():
	set_tree_visible()
	if variety == "oak":
		$TreeTopArea/A.set_deferred("disabled", true)
	elif variety == "spruce":
		$TreeTopArea/B.set_deferred("disabled", true)
	elif variety == "birch":
		$TreeTopArea/C.set_deferred("disabled", true)
	elif variety == "evergreen":
		$TreeTopArea/D.set_deferred("disabled", true)
	elif variety == "pine":
		$TreeTopArea/E.set_deferred("disabled", true)


func set_tree_transparent():
	tween.interpolate_property(animated_tree_top_sprite, "modulate:a",
		animated_tree_top_sprite.get_modulate().a, 0.4, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_top_sprite, "modulate:a",
		tree_top_sprite.get_modulate().a, 0.4, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_stump_sprite, "modulate:a",
		tree_stump_sprite.get_modulate().a, 0.4, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_bottom_sprite, "modulate:a",
		tree_bottom_sprite.get_modulate().a, 0.4, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func set_tree_visible():
	tween.interpolate_property(animated_tree_top_sprite, "modulate:a",
		animated_tree_top_sprite.get_modulate().a, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_top_sprite, "modulate:a",
		tree_top_sprite.get_modulate().a, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_stump_sprite, "modulate:a",
		tree_stump_sprite.get_modulate().a, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.interpolate_property(tree_bottom_sprite, "modulate:a",
		tree_bottom_sprite.get_modulate().a, 1.0, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_TreeTopArea_area_entered(_area):
	set_tree_transparent()
func _on_TreeTopArea_area_exited(_area):
	set_tree_visible()

func _on_VisibilityNotifier2D_screen_entered():
	animated_tree_top_sprite.playing = true
	show()
func _on_VisibilityNotifier2D_screen_exited():
	animated_tree_top_sprite.playing = false
	hide()

func _on_RandomLeavesFallingTimer_timeout():
	random_leaves_falling_timer.wait_time = rng.randi_range(15.0, 60.0)
	if str(phase) == "5":
		InstancedScenes.initiateLeavesFallingEffect(variety, position)


func _on_ResetTempHealthTimer_timeout():
	temp_health = 3
