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
	hide()
	setTreeBranchType(variety)

func setTreeBranchType(num):
	if num <= 2:
		tree_variety = 'D'
	elif num <= 5:
		tree_variety = 'B'
	elif num <= 8:
		tree_variety = 'A'
	else:
		tree_variety = 'C'
	log_sprite.texture = Images.tree_branch_objects[num]

func hit(tool_name, var special_ability = ""):
	if not destroyed:
		destroyed = true
		Server.generated_map["log"].erase(name)
		Tiles.add_valid_tiles(location)
		sound_effects.stream = Sounds.stump_break
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		animation_player.play("break")
		InstancedScenes.initiateTreeHitEffect(tree_variety, "trunk break", position+Vector2(-16, 16))
		var amt = Stats.return_item_drop_quantity(tool_name, "branch")
		CollectionsData.resources["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position, amt)
		yield(get_tree().create_timer(1.2), "timeout")
		queue_free()

func _on_BranchHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		hit(_area.tool_name)
	if _area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-16,16), rand_range(-16,16)))

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
