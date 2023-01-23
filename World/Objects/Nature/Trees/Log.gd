extends Node2D

onready var log_sprite: Sprite = $Log
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var randomNum
var variety #number
var tree_variety
var location
var destroyed: bool = false

func _ready():
	randomize()
	visible = false
	setTreeBranchType()

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
	log_sprite.set_deferred("texture", Images.tree_branch_objects[variety]) 

func hit(tool_name, var special_ability = ""):
	if not destroyed:
		destroyed = true
		if MapData.world["log"].has(name):
			MapData.world["log"].erase(name)
		Tiles.add_valid_tiles(location)
		sound_effects.set_deferred("stream", Sounds.stump_break) 
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12)) 
		sound_effects.call_deferred("play")
		animation_player.call_deferred("play", "break")
		InstancedScenes.initiateTreeHitEffect(tree_variety, "trunk break", position+Vector2(-16, 16))
		var amt = Stats.return_item_drop_quantity(tool_name, "branch")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position, amt)
		yield(get_tree().create_timer(1.2), "timeout")
		queue_free()

func _on_BranchHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		call_deferred("hit", _area.tool_name)
	if _area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-16,16), rand_range(-16,16)))

func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")

func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
