extends Node2D

#@onready var log_sprite: Sprite2D = $Log
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var randomNum
var variety #number
var tree_variety
var location
var destroyed: bool = false

var atlas_tile_cord = {
	1: Vector2i(13,31),
	2: Vector2i(14,31),
	3: Vector2i(15,31),
	4: Vector2i(13,32),
	5: Vector2i(14,32),
	6: Vector2i(15,32),
	7: Vector2i(13,33),
	8: Vector2i(14,33),
	9: Vector2i(15,33),
	10: Vector2i(13,34),
	11: Vector2i(14,34),
	12: Vector2i(15,34)
}

func _ready():
	Tiles.remove_valid_tiles(location)
	setTreeBranchType()

func remove_from_world():
	$BranchHurtBox.call_deferred("queue_free")
	$MovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")

func setTreeBranchType():
	variety = int(variety)
	if variety <= 2:
		set_deferred("tree_variety", "evergreen")
	elif variety <= 5:
		set_deferred("tree_variety", "spruce")
	elif variety <= 8:
		set_deferred("tree_variety", "oak")
	else:
		set_deferred("tree_variety", "birch")
	$TileMap.set_cell(0,Vector2i(0,-1),0,atlas_tile_cord[variety])

func hit(tool_name, special_ability = ""):
	if not destroyed:
		destroyed = true
		if MapData.world["log"].has(name):
			MapData.world["log"].erase(name)
		$Break.play("break")
		$TileMap.erase_cell(0,Vector2i(0,-1))
		Tiles.add_valid_tiles(location)
		sound_effects.set_deferred("stream", Sounds.stump_break) 
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12)) 
		sound_effects.call_deferred("play")
		animation_player.call_deferred("play", "break")
		var amt = Stats.return_item_drop_quantity(tool_name, "branch")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position+Vector2(8,-8), amt)
		await get_tree().create_timer(1.2).timeout
		call_deferred("queue_free")

func _on_BranchHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-16,16), randf_range(-16,16)))
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		call_deferred("hit", _area.tool_name)

func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
