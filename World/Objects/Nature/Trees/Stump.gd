extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var tree_stump_sprite: Sprite2D = $TreeSprites/TreeStump
@onready var stump_break: AnimatedSprite2D = $TreeSprites/Break
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var rng = RandomNumberGenerator.new()

var tree_object
var location = Vector2i(0,0)
var health 
var variety 
var destroyed: bool = false

func _ready():
	Tiles.remove_valid_tiles(location+Vector2i(-1,0), Vector2i(2,2))
	call_deferred("setTexture", tree_object)

func remove_from_world():
	$TreeHurtbox.call_deferred("queue_free")
	$MovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")


func setTexture(tree):
	tree_stump_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/large stump.png"))
	match variety:
		"oak":
			stump_break.offset = Vector2i(-7,7)
		"apple":
			stump_break.offset = Vector2i(-6,6)
		"birch":
			stump_break.offset = Vector2i(-7,3)
		"chery":
			stump_break.offset = Vector2i(-7,6)
		"evergreen":
			stump_break.offset = Vector2i(-6,6)
		"pear":
			stump_break.offset = Vector2i(-6,7)
		"pine":
			stump_break.offset = Vector2i(-6,7)
		"plum":
			stump_break.offset = Vector2i(-6,7)
		"spruce":
			stump_break.offset = Vector2i(-7,7)
	


func hit(tool_name):
	health -= Stats.return_tool_damage(tool_name)
	if MapData.world[Util.return_chunk_from_location(location)]["stump"].has(name):
		MapData.world[Util.return_chunk_from_location(location)]["stump"][name]["h"] = health
	if health > 0:
		sound_effects.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		animation_player.call_deferred("stop")
		if Server.player_node.get_position().x <= get_position().x:
			animation_player.call_deferred("play", "stump hit right")
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position)
		else: 
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position)
			animation_player.call_deferred("play", "stump hit right")
	elif not destroyed:
		destroyed = true
		if MapData.world[Util.return_chunk_from_location(location)]["stump"].has(name):
			MapData.world[Util.return_chunk_from_location(location)]["stump"].erase(name)
		Tiles.add_valid_tiles(location+Vector2i(-1,0), Vector2(2,2))
		sound_effects.set_deferred("stream", Sounds.stump_break)
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		animation_player.call_deferred("play", "stump destroyed")
		var amt = Stats.return_item_drop_quantity(tool_name, "stump")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position, amt)
		stump_break.play(variety)
		$TreeSprites/Break.play(variety)
		await sound_effects.finished
		call_deferred("queue_free")


func _on_tree_hurtbox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-16,16), randf_range(-18,12)))
		health -= Stats.FIRE_DEBUFF_DAMAGE
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		call_deferred("hit", area.tool_name)


func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")


