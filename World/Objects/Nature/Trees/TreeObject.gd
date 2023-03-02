extends Area2D

@onready var tree_stump_sprite: Sprite2D = $TreeSprites/TreeStump
@onready var tree_bottom_sprite: Sprite2D = $TreeSprites/TreeBottom
@onready var tree_top_sprite: Sprite2D = $TreeSprites/TreeTop
@onready var animated_tree_top_sprite: AnimatedSprite2D = $TreeSprites/AnimatedTop
@onready var sound_effects_stump: AudioStreamPlayer2D = $SoundEffectsStump
@onready var sound_effects_tree: AudioStreamPlayer2D = $SoundEffectsTree
@onready var animation_player_tree: AnimationPlayer = $AnimationPlayerTree
@onready var animation_player_stump: AnimationPlayer = $AnimationPlayerStump
@onready var random_leaves_falling_timer: Timer = $RandomLeavesFallingTimer

var rng = RandomNumberGenerator.new()

var location = Vector2i(0,0)
var variety = "oak"
var hit_dir
var health = 40
var adjusted_leaves_falling_pos 
var biome
var tree_fallen = false
var destroyed = false

var object_name = "tree"

var phase = "5"

var temp_health: int = 3

func _ready():
	rng.randomize()
	Tiles.remove_valid_tiles(location+Vector2i(-1,0), Vector2(2,2))
	$TreeSprites/AnimatedTop.play("default")
	MapData.connect("refresh_crops",Callable(self,"refresh_tree_type"))
	call_deferred("set_tree")


func remove_from_world():
	$TreeHurtbox.call_deferred("queue_free")
	$TreeTopArea.call_deferred("queue_free")
	$MovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")


func set_tree():
	phase = str(phase)
	if phase == "5" and Util.isNonFruitTree(variety): # grown nonfruit tree
		animated_tree_top_sprite.call_deferred("show")
		tree_bottom_sprite.call_deferred("show")
		tree_stump_sprite.call_deferred("show")
		tree_top_sprite.call_deferred("hide")
		$TreeSprites/TreeSapling.call_deferred("hide")
		setGrownTreeTexture()
	elif (phase == "mature1" or phase == "mature2" or phase == "harvest" or phase == "empty") and Util.isFruitTree(MapData.world["tree"][name]["v"]): # grown fruit tree
		animated_tree_top_sprite.call_deferred("show")
		tree_bottom_sprite.call_deferred("show")
		tree_stump_sprite.call_deferred("show")
		tree_top_sprite.call_deferred("hide")
		$TreeSprites/TreeSapling.call_deferred("hide")
		setGrownFruitTreeTexture()
	else:
		animated_tree_top_sprite.call_deferred("hide")
		tree_bottom_sprite.call_deferred("hide")
		tree_stump_sprite.call_deferred("hide")
		tree_top_sprite.call_deferred("hide")
		$TreeSprites/TreeSapling.call_deferred("show")
		$TreeSprites/TreeSapling.set_deferred( "texture", load("res://Assets/Images/tree_sets/"+ variety +"/growing/"+ phase +".png"))


func harvest():
	if phase == "harvest":
		$CollisionShape2D.set_deferred("disabled", true)
		if Util.chance(5):
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 0), 3)
		elif Util.chance(25):
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 0), 2)
		else:
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0,0), 1)
		phase = "empty"
		MapData.world["tree"][name]["p"] = "empty"
		await get_tree().idle_frame
		refresh_tree_type()


func refresh_tree_type():
	if MapData.world["tree"].has(name):
		if phase != "5" and Util.isNonFruitTree(MapData.world["tree"][name]["v"]):
			phase = MapData.world["tree"][name]["p"]
			set_tree()
		elif phase != "harvest" and Util.isFruitTree(MapData.world["tree"][name]["v"]):
			phase = MapData.world["tree"][name]["p"]
			set_tree()

func setGrownFruitTreeTexture():
	random_leaves_falling_timer.set_deferred("wait_time", rng.randi_range(15.0, 60.0))
	if health < Stats.STUMP_HEALTH:
		tree_fallen = true
		call_deferred("disable_tree_top_collision_box")
		animated_tree_top_sprite.call_deferred("hide")
		tree_bottom_sprite.call_deferred("hide")
	call_deferred("set_tree_top_collision_shape")
	tree_stump_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/stump.png"))
	tree_bottom_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/bottom.png"))
	$TreeChipParticles.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/effects/chip.png"))
	$TreeLeavesParticles.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/effects/leaves.png"))
	animated_tree_top_sprite.set_deferred("frame", rng.randi_range(0,19))
	animated_tree_top_sprite.set_deferred("sprite_frames", load("res://Assets/Images/tree_sets/"+ variety +"/mature/animated.tres"))
	match biome:
		"forest":
			tree_top_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/tops/"+ phase +".png"))
			animated_tree_top_sprite.set_deferred("animation", phase)
		"snow":
			tree_top_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/tops/empty winter.png"))
			animated_tree_top_sprite.set_deferred("animation", "snow")
	match variety:
		"apple":
			animated_tree_top_sprite.set_deferred("offset", Vector2(-1,-17))
		"cherry":
			animated_tree_top_sprite.set_deferred("offset", Vector2(-1,-17))
		"plum":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-28))
		"pear":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-23))
	if phase == "harvest":
		$CollisionShape2D.set_deferred("disabled", false)
	else:
		$CollisionShape2D.set_deferred("disabled", true)

func setGrownTreeTexture():
	random_leaves_falling_timer.set_deferred("wait_time", rng.randi_range(15.0, 60.0))
	if health < Stats.STUMP_HEALTH:
		tree_fallen = true
		call_deferred("disable_tree_top_collision_box")
		animated_tree_top_sprite.call_deferred("hide")
		tree_bottom_sprite.call_deferred("hide")
	call_deferred("set_tree_top_collision_shape")
	tree_stump_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/stump.png"))
	tree_bottom_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/bottom.png"))
	animated_tree_top_sprite.set_deferred("frame", rng.randi_range(0,19))
	match biome:
		"forest":
			tree_top_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/top.png"))
			animated_tree_top_sprite.set_deferred("sprite_frames", load("res://Assets/Images/tree_sets/"+ variety +"/mature/animated top.tres"))
		"snow":
			tree_top_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/mature/top winter.png"))
			animated_tree_top_sprite.set_deferred("sprite_frames", load("res://Assets/Images/tree_sets/"+ variety +"/mature/animated top winter.tres"))
	match variety:
		"oak":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-33))
		"spruce":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-33))
		"birch":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-38))
		"evergreen":
			animated_tree_top_sprite.set_deferred("offset", Vector2(-1,-23))
		"pine":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-37))
	animated_tree_top_sprite.play("default")

func hit(tool_name):
	if not destroyed:
		if not (phase == "5" and Util.isNonFruitTree(variety)) and not (phase == "mature1" or phase == "mature2" or phase == "harvest" or phase == "empty" and Util.isFruitTree(variety)):
			animation_player_stump.call_deferred("play", "sapling hit")
			$ResetTempHealthTimer.call_deferred("start")
			temp_health -= 1
			sound_effects_tree.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood hit.mp3"))
			sound_effects_tree.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
			sound_effects_tree.call_deferred("play")
			if temp_health <= 0 and not destroyed: 
				call_deferred("destroy", "sapling")
		else:
			if health == 100:
				InstancedScenes.initiateBirdEffect(position)
			health -= Stats.return_tool_damage(tool_name)
			if MapData.world["tree"].has(name):
				MapData.world["tree"][name]["h"] = health
			if health >= Stats.STUMP_HEALTH:
				InstancedScenes.initiateLeavesFallingEffect(variety, position)
				sound_effects_tree.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
				sound_effects_tree.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
				sound_effects_tree.call_deferred("play") 
				animation_player_tree.call_deferred("stop")
				if Server.player_node.get_position().x <= get_position().x:
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position)
					animation_player_tree.call_deferred("play", "tree hit right")
				else: 
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position)
					animation_player_tree.call_deferred("play", "tree hit left")
			elif not tree_fallen:
				if health <= 0 and not destroyed:
					call_deferred("play", tool_name)
				tree_fallen = true
				call_deferred("disable_tree_top_collision_box")
				sound_effects_stump.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
				sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
				sound_effects_stump.call_deferred("play")
				sound_effects_tree.set_deferred("stream", Sounds.tree_break)
				sound_effects_tree.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -14))
				sound_effects_tree.call_deferred("play")
				if Server.player_node.get_position().x <= get_position().x:
					$TreeSprites/TopBreak.rotation = 90
					animation_player_tree.call_deferred("play", "tree fall right")
					await animation_player_tree.animation_finished
					play_tree_break_animation("right")
					var amt = Stats.return_item_drop_quantity(tool_name, "tree")
					PlayerData.player_data["collections"]["resources"]["wood"] += amt
					InstancedScenes.intitiateItemDrop("wood", position+Vector2(65, -8), amt)
					if Util.chance(5):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 3)
					elif Util.chance(15):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 2)
					elif Util.chance(25):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 1)
				
				else:
					$TreeSprites/TopBreak.rotation = -90
					animation_player_tree.call_deferred("play", "tree fall left")
					await animation_player_tree.animation_finished
					play_tree_break_animation("left")
					var amt = Stats.return_item_drop_quantity(tool_name, "tree")
					PlayerData.player_data["collections"]["resources"]["wood"] += amt
					InstancedScenes.intitiateItemDrop("wood", position+Vector2(-65, -8), amt)
					if Util.chance(5):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 3)
					elif Util.chance(15):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 2)
					elif Util.chance(25):
						InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 1)
			elif health >= 1:
				sound_effects_stump.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
				sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
				sound_effects_stump.call_deferred("play")
				animation_player_stump.call_deferred("stop")
				if Server.player_node.get_position().x <= get_position().x:
					animation_player_stump.call_deferred("play", "stump hit right")
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position)
				else: 
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position)
					animation_player_stump.call_deferred("play", "stump hit right")
			if health <= 0 and not destroyed: 
				call_deferred("destroy", tool_name)


func destroy(tool_name):
	MapData.world["tree"].erase(name)
	destroyed = true
	Tiles.add_valid_tiles(location+Vector2i(-1,0), Vector2(2,2))
	if not tool_name == "sapling":
		play_stump_break_animation()
		animation_player_stump.call_deferred("play", "stump destroyed")
		sound_effects_stump.set_deferred("stream", Sounds.stump_break)
		sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects_stump.call_deferred("play")
		var amt = Stats.return_item_drop_quantity(tool_name, "stump")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position+Vector2(0, 12), amt)
		await get_tree().create_timer(3.0).timeout
	else:
		animation_player_stump.call_deferred("play", "sapling destroyed")
		sound_effects_stump.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3"))
		sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
		sound_effects_stump.call_deferred("play")
		await get_tree().create_timer(3.0).timeout
	call_deferred("queue_free")

### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.special_ability == "fire buff" and phase == "5":
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-16,16), randf_range(-10,22)))
		health -= Stats.FIRE_DEBUFF_DAMAGE
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		call_deferred("hit", _area.tool_name)


### Tree modulate functions
func set_tree_top_collision_shape():
	$TreeTopArea.get_node(variety).set_deferred("disabled", false)

func disable_tree_top_collision_box():
	set_tree_visible()
	$TreeTopArea.get_node(variety).set_deferred("disabled", true)

func set_tree_transparent():
	var tween = get_tree().create_tween()
	tween.tween_property(animated_tree_top_sprite, "modulate:a", 0.4, 0.5)
	tween.tween_property(tree_top_sprite, "modulate:a", 0.4, 0.5)

func set_tree_visible():
	var tween = get_tree().create_tween()
	tween.tween_property(animated_tree_top_sprite, "modulate:a", 1.0, 0.5)
	tween.tween_property(tree_top_sprite, "modulate:a", 1.0, 0.5)

func play_tree_break_animation(fall_side):
	$TreeSprites/TopBreak.show()
	match variety:
		"oak":
			$TreeSprites/TopBreak.offset = Vector2(-3,-45)
			if fall_side == "left":
				#$TreeSprites/TopBreak.rotation = -90
				if biome == "snow":
					$TreeSprites/TopBreak.play("left oak winter")
				else:
					$TreeSprites/TopBreak.play("left oak")
			else:
				#$TreeSprites/TopBreak.rotation = 90
				if biome == "snow":
					$TreeSprites/TopBreak.play("right oak winter")
				else:
					$TreeSprites/TopBreak.play("right oak")

func play_stump_break_animation():
	$TreeSprites/StumpBreak.show()
	match variety:
		"oak":
			$TreeSprites/StumpBreak.offset = Vector2(-7,7)
	$TreeSprites/StumpBreak.play(variety)


func _on_TreeTopArea_area_entered(_area):
	call_deferred("set_tree_transparent")
	
func _on_TreeTopArea_area_exited(_area):
	call_deferred("set_tree_visible")

func _on_RandomLeavesFallingTimer_timeout():
	random_leaves_falling_timer.set_deferred("wait_time", rng.randi_range(15.0, 60.0))
	if str(phase) == "5":
		InstancedScenes.initiateLeavesFallingEffect(variety, position)

func _on_ResetTempHealthTimer_timeout():
	temp_health = 3

