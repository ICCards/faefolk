extends Area2D

@onready var tree_stump_sprite: Sprite2D = $TreeSprites/TreeStump
@onready var tree_bottom_sprite: Sprite2D = $TreeSprites/TreeBottom
@onready var tree_top_sprite: Sprite2D = $TreeSprites/TreeTop
@onready var animated_tree_top_sprite: AnimatedSprite2D = $TreeSprites/AnimatedTop
@onready var fruit_fall: AnimatedSprite2D = $TreeSprites/FruitFall
@onready var sound_effects_stump: AudioStreamPlayer2D = $SoundEffectsStump
@onready var sound_effects_tree: AudioStreamPlayer2D = $SoundEffectsTree
@onready var animation_player_tree: AnimationPlayer = $AnimationPlayerTree
@onready var animation_player_stump: AnimationPlayer = $AnimationPlayerStump
@onready var random_leaves_falling_timer: Timer = $RandomLeavesFallingTimer

var rng = RandomNumberGenerator.new()

@export var location: Vector2i
@export var variety: String
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
	Tiles.remove_valid_tiles(location+Vector2i(-1,0), Vector2i(2,2))
	#MapData.connect("refresh_crops",Callable(self,"refresh_tree_type"))
	call_deferred("set_tree")
	random_leaves_falling_timer.set_deferred("wait_time", rng.randi_range(15.0, 60.0))
	random_leaves_falling_timer.call_deferred("start")


#func _enter_tree():
#	set_multiplayer_authority(str(name).to_int())


func remove_from_world():
	$TreeHurtbox.call_deferred("queue_free")
	$TreeTopArea.call_deferred("queue_free")
	$MovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")


func set_tree():
	if phase == "5" and Util.isNonFruitTree(variety): # grown nonfruit tree
		animated_tree_top_sprite.call_deferred("show")
		tree_bottom_sprite.call_deferred("show")
		tree_stump_sprite.call_deferred("show")
		tree_top_sprite.call_deferred("hide")
		$TreeSprites/TreeSapling.call_deferred("hide")
		setGrownTreeTexture()
	elif (phase == "mature1" or phase == "mature2" or phase == "harvest" or phase == "empty") and Util.isFruitTree(variety): # grown fruit tree
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
	if phase == "harvest" and health > 40:
		$CollisionShape2D.set_deferred("disabled", true)
		phase = "empty"
		#MapData.world["tree"][name]["p"] = "empty"
		refresh_tree_type()
		fruit_fall.frame = 0
		fruit_fall.show()
		fruit_fall.play(variety)
		sound_effects_stump.stream = load("res://Assets/Sound/Sound effects/Tree/fallDown.mp3")
		sound_effects_stump.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects_stump.play()
		await fruit_fall.animation_finished
		fruit_fall.hide()
		if Util.chance(25):
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0,4), 3)
		elif Util.chance(25):
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0,4), 2)
		else:
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0,4), 1)


func refresh_tree_type():
	if MapData.world["tree"].has(name):
		if phase != "5" and Util.isNonFruitTree(variety):
			phase = MapData.world["tree"][name]["p"]
			set_tree()
		elif phase != "harvest" and Util.isFruitTree(variety):
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
			fruit_fall.set_deferred("offset", Vector2(0,-19))
		"cherry":
			animated_tree_top_sprite.set_deferred("offset", Vector2(-1,-17))
			fruit_fall.set_deferred("offset", Vector2(0,-20))
		"plum":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-28))
			fruit_fall.set_deferred("offset", Vector2(0,-20))
		"pear":
			animated_tree_top_sprite.set_deferred("offset", Vector2(0,-23))
			fruit_fall.set_deferred("offset", Vector2(0,-21))
	if phase == "harvest":
		$CollisionShape2D.set_deferred("disabled", false)
	else:
		$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().process_frame
	if biome == "snow":
		animated_tree_top_sprite.play("snow")
	else:
		animated_tree_top_sprite.play(phase)

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
	await get_tree().process_frame
	animated_tree_top_sprite.play("default")


func hit(data):
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
			health = data["health"]
			if health >= Stats.STUMP_HEALTH:
				InstancedScenes.initiateLeavesFallingEffect(variety, position)
				sound_effects_tree.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
				sound_effects_tree.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
				sound_effects_tree.call_deferred("play") 
				animation_player_tree.call_deferred("stop")
				if Server.world.get_node("Players/"+str(data["player_id"])).get_position().x <= get_position().x:
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position)
					animation_player_tree.call_deferred("play", "tree hit right")
				else: 
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position)
					animation_player_tree.call_deferred("play", "tree hit left")
			elif not tree_fallen:
#				if health <= 0 and not destroyed:
#					destroy("")
				tree_fallen = true
				tree_fall_break(data)
			elif health >= 1:
				sound_effects_stump.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
				sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
				sound_effects_stump.call_deferred("play")
				animation_player_stump.call_deferred("stop")
				if Server.world.get_node("Players/"+str(data["player_id"])).get_position().x <= get_position().x:
					animation_player_stump.call_deferred("play", "stump hit right")
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position)
				else: 
					InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position)
					animation_player_stump.call_deferred("play", "stump hit right")
#			if health <= 0 and not destroyed: 
#				call_deferred("destroy", tool_name)


func tree_fall_break(data):
	call_deferred("disable_tree_top_collision_box")
	sound_effects_stump.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
	sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
	sound_effects_stump.call_deferred("play")
	sound_effects_tree.set_deferred("stream", Sounds.tree_break)
	sound_effects_tree.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -14))
	sound_effects_tree.call_deferred("play")
	if Server.world.get_node("Players/"+str(data["player_id"])).get_position().x <= get_position().x:
		animation_player_tree.call_deferred("play", "tree fall right")
		await animation_player_tree.animation_finished
		play_tree_break_animation("right")
		if data["player_id"] == Server.player_node.name:
			var amt = Stats.return_item_drop_quantity(data["tool_name"], "tree")
			PlayerData.player_data["collections"]["resources"]["wood"] += amt
			InstancedScenes.intitiateItemDrop("wood", position+Vector2(65, -8), amt)
			if Util.chance(5):
				InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 3)
			elif Util.chance(15):
				InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 2)
			elif Util.chance(25):
				InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(65, -8), 1)
	else:  
			animation_player_tree.call_deferred("play", "tree fall left")
			await animation_player_tree.animation_finished
			play_tree_break_animation("left")
			if data["player_id"] == Server.player_node.name:
				var amt = Stats.return_item_drop_quantity(data["tool_name"], "tree")
				PlayerData.player_data["collections"]["resources"]["wood"] += amt
				InstancedScenes.intitiateItemDrop("wood", position+Vector2(-65, -8), amt)
				if Util.chance(5):
					InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 3)
				elif Util.chance(15):
					InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 2)
				elif Util.chance(25):
					InstancedScenes.intitiateItemDrop(variety+" seeds", position+Vector2(-65, -8), 1)


func destroy(data):
	#MapData.remove_object("tree",name)
	if not destroyed:
		destroyed = true
		if not tree_fallen:
			play_tree_break_animation(data)
		Tiles.add_valid_tiles(location+Vector2i(-1,0), Vector2(2,2))
		if phase != "sapling" and phase != "1" and phase != "2" and phase != "3" and phase != "4":
			play_stump_break_animation()
			animation_player_stump.call_deferred("play", "stump destroyed")
			sound_effects_stump.set_deferred("stream", Sounds.stump_break)
			sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
			sound_effects_stump.call_deferred("play")
			if data["player_id"] == Server.player_node.name:
				var amt = Stats.return_item_drop_quantity(data["tool_name"], "stump")
				PlayerData.player_data["collections"]["resources"]["wood"] += amt
				InstancedScenes.intitiateItemDrop("wood",position,amt)
		else:
			animation_player_stump.call_deferred("play", "sapling destroyed")
			sound_effects_stump.set_deferred("stream", load("res://Assets/Sound/Sound effects/Building/wood/wood break.mp3"))
			sound_effects_stump.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
			sound_effects_stump.call_deferred("play")
		await get_tree().create_timer(3.0).timeout
		call_deferred("queue_free")

### Tree hurtbox
func _on_Hurtbox_area_entered(_area):
	print("TREE HURTBOX ENTERTED ")
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
#	if _area.special_ability == "fire buff" and phase == "5":
#		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-16,16), randf_range(-10,22)))
#		health -= Stats.FIRE_DEBUFF_DAMAGE
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		get_parent().rpc_id(1,"nature_object_hit",Server.player_node.name,"tree",name,location,_area.tool_name)


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
	match variety:
		"oak":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-45)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("oak winter")
				else:
					$TreeSprites/TopBreakLeft.play("oak")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-46)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("oak winter")
				else:
					$TreeSprites/TopBreakRight.play("oak")
		"birch":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("birch winter")
				else:
					$TreeSprites/TopBreakLeft.play("birch")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("birch winter")
				else:
					$TreeSprites/TopBreakRight.play("birch")
		"evergreen":
				if fall_side == "left":
					$TreeSprites/TopBreakLeft.show()
					$TreeSprites/TopBreakLeft.offset = Vector2(-3,-41)
					if biome == "snow":
						$TreeSprites/TopBreakLeft.play("evergreen winter")
					else:
						$TreeSprites/TopBreakLeft.play("evergreen")
				else:
					$TreeSprites/TopBreakRight.show()
					$TreeSprites/TopBreakRight.offset = Vector2(-3,-41)
					if biome == "snow":
						$TreeSprites/TopBreakRight.play("evergreen winter")
					else:
						$TreeSprites/TopBreakRight.play("evergreen")
		"pine":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-46)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("pine winter")
				else:
					$TreeSprites/TopBreakLeft.play("pine")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("pine winter")
				else:
					$TreeSprites/TopBreakRight.play("pine")
		"spruce":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("spruce winter")
				else:
					$TreeSprites/TopBreakLeft.play("spruce")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-46)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("spruce winter")
				else:
					$TreeSprites/TopBreakRight.play("spruce")
		"apple":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-46)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("apple winter")
				else:
					$TreeSprites/TopBreakLeft.play("apple")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("apple winter")
				else:
					$TreeSprites/TopBreakRight.play("apple")
		"cherry":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("cherry winter")
				else:
					$TreeSprites/TopBreakLeft.play("cherry")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("cherry winter")
				else:
					$TreeSprites/TopBreakRight.play("cherry")
		"plum":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-46)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("plum winter")
				else:
					$TreeSprites/TopBreakLeft.play("plum")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("plum winter")
				else:
					$TreeSprites/TopBreakRight.play("plum")
		"pear":
			if fall_side == "left":
				$TreeSprites/TopBreakLeft.show()
				$TreeSprites/TopBreakLeft.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakLeft.play("pear winter")
				else:
					$TreeSprites/TopBreakLeft.play("pear")
			else:
				$TreeSprites/TopBreakRight.show()
				$TreeSprites/TopBreakRight.offset = Vector2(-3,-47)
				if biome == "snow":
					$TreeSprites/TopBreakRight.play("pear winter")
				else:
					$TreeSprites/TopBreakRight.play("pear")
	if fall_side == "left":
		await $TreeSprites/TopBreakLeft.animation_finished
		$TreeSprites/TopBreakLeft.hide()
	else:
		await $TreeSprites/TopBreakRight.animation_finished
		$TreeSprites/TopBreakRight.hide()

func play_stump_break_animation():
	$TreeSprites/StumpBreak.show()
	match variety:
		"oak":
			$TreeSprites/StumpBreak.offset = Vector2(-7,7)
		"birch":
			$TreeSprites/StumpBreak.offset = Vector2(-7,6)
		"evergreen":
			$TreeSprites/StumpBreak.offset = Vector2(-6,6)
		"pine":
			$TreeSprites/StumpBreak.offset = Vector2(-7,6)
		"spruce":
			$TreeSprites/StumpBreak.offset = Vector2(-7,6)
		"apple":
			$TreeSprites/StumpBreak.offset = Vector2(-7,7)
		"cherry":
			$TreeSprites/StumpBreak.offset = Vector2(-7,6)
		"plum":
			$TreeSprites/StumpBreak.offset = Vector2(-6,6)
		"pear":
			$TreeSprites/StumpBreak.offset = Vector2(-6,6)
	$TreeSprites/StumpBreak.play(variety)
	await  $TreeSprites/StumpBreak.animation_finished
	$TreeSprites/StumpBreak.hide()
	

func _on_TreeTopArea_area_entered(_area):
	call_deferred("set_tree_transparent")
	
func _on_TreeTopArea_area_exited(_area):
	call_deferred("set_tree_visible")

func _on_RandomLeavesFallingTimer_timeout():
	random_leaves_falling_timer.set_deferred("wait_time", rng.randi_range(15.0, 60.0))
	if str(phase) == "5" and health > 40:
		InstancedScenes.initiateLeavesFallingEffect(variety, position)

func _on_ResetTempHealthTimer_timeout():
	temp_health = 3


