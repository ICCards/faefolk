extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var rng = RandomNumberGenerator.new()


var location
var variety
var health
var destroyed: bool = false

func _ready():
	rng.randomize()
	Tiles.remove_valid_tiles(location)
	call_deferred("setTexture")
	
func remove_from_world():
	$SmallHurtBox.call_deferred("queue_free")
	$SmallMovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")

func setTexture():
	$SmallOre.set_cell(0,Vector2i(0,-1),0,Constants.small_ore_atlas_cords[variety][rng.randi_range(1,6)])


func hit(data):
	if not destroyed:
		sound_effects.set_deferred("stream", Sounds.ore_hit[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(randf_range(-6,6), randf_range(-6,6)))
		animation_player.call_deferred("play", "hit")


func destroy(data):
	if not destroyed:
		destroyed = true
#		PlayerData.player_data["skill_experience"]["mining"] += 1
#		MapData.remove_object("ore", name)
		Tiles.add_valid_tiles(location)
		sound_effects.set_deferred("stream", Sounds.ore_break[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "small ore break", position)
#		var amount = Stats.return_item_drop_quantity(tool_name, "small ore")
#		Util.add_to_collection(variety, amount)
#		if variety == "stone1" or variety == "stone2":
#			InstancedScenes.intitiateItemDrop("stone", position, amount)
#		else:
#			InstancedScenes.intitiateItemDrop(variety, position, amount)
		animation_player.call_deferred("play", "small_ore_break")
		await sound_effects.finished
		await get_tree().create_timer(0.6).timeout
		call_deferred("queue_free")


func _on_SmallHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		get_parent().rpc_id(1,"nature_object_hit",Server.player_node.name,"ore",name,location,_area.tool_name)
	if _area.special_ability == "fire buff":
		health -= Stats.FIRE_DEBUFF_DAMAGE
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-8, 8), randf_range(-16,0)))


func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")
