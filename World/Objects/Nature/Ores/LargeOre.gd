extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var rng = RandomNumberGenerator.new()

var location: Vector2i
var variety
var health
var large_break = false
var destroyed = false


func _ready():
	rng.randomize()
	call_deferred("setTexture")

func remove_from_world():
	$BigHurtBox.call_deferred("queue_free")
	$BigMovementCollisionBox.call_deferred("queue_free")
	$SmallMovementCollisionBox.call_deferred("queue_free")
	$SmallMovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")

func setTexture():
	$LargeOre.set_cell(0,Vector2i(0,-1),0,Constants.large_ore_atlas_cords[variety])
	$SmallOre.set_cell(0,Vector2i(0,-1),0,Constants.small_ore_atlas_cords[variety][rng.randi_range(1,6)])
	if health <= 40:
		$BigHurtBox/bigHurtBox.set_deferred("disabled", true)
		$BigMovementCollisionBox/BigMovementBox.set_deferred("disabled", true)
		$SmallHurtBox/smallHurtBox.set_deferred("disabled", false)
		$SmallMovementCollisionBox/CollisionShape2D.set_deferred("disabled", false)
		$LargeOre.call_deferred("hide")
		$SmallOre.call_deferred("show")
		large_break = true
		Tiles.remove_valid_tiles(location+Vector2i(-1,0), Vector2(2,1))
	else:
		$LargeOre.call_deferred("show")
		$SmallOre.call_deferred("hide")
		Tiles.remove_valid_tiles(location+Vector2i(-1,0), Vector2(2,2))


func hit(tool_name):
	rng.randomize()
	health -= Stats.return_tool_damage(tool_name)
	if MapData.world[Util.return_chunk_from_location(location)]["ore_large"].has(name):
		MapData.world[Util.return_chunk_from_location(location)]["ore_large"][name]["h"] = health
	if health > 40:
		sound_effects.set_deferred("stream", Sounds.ore_hit[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(rng.randi_range(-12,12), rng.randi_range(-8,8)))
		animation_player.call_deferred("play", "large ore hit")
	elif not large_break:
		Tiles.add_valid_tiles(location+Vector2i(-1,-1), Vector2(2,1))
		large_break = true
		sound_effects.set_deferred("stream", Sounds.ore_break[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "large ore break", position+Vector2(rng.randi_range(-6,6), rng.randi_range(-4,4)))
		var amount = Stats.return_item_drop_quantity(tool_name, "large ore")
		Util.add_to_collection(variety, amount)
		if variety == "stone1" or variety == "stone2":
			InstancedScenes.intitiateItemDrop("stone", position, amount)
		else:
			InstancedScenes.intitiateItemDrop(variety, position, amount)
		animation_player.call_deferred("play", "large ore break")
	elif health >= 1:
		sound_effects.set_deferred("stream", Sounds.ore_hit[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(randf_range(-6,6), randf_range(-6,6)))
		animation_player.call_deferred("play", "small ore hit")
	elif health <= 0 and not destroyed:
		destroyed = true
		PlayerData.player_data["skill_experience"]["mining"] += 1
		MapData.remove_object("ore_large",name,location)
		Tiles.add_valid_tiles(location+Vector2i(-1,0), Vector2(2,1))
		sound_effects.set_deferred("stream", Sounds.ore_break[rng.randi_range(0, 2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		InstancedScenes.initiateOreHitEffect(variety, "small ore break", position)
		var amount = Stats.return_item_drop_quantity(tool_name, "small ore")
		Util.add_to_collection(variety, amount)
		if variety == "stone1" or variety == "stone2":
			InstancedScenes.intitiateItemDrop("stone", position, amount)
		else:
			InstancedScenes.intitiateItemDrop(variety, position, amount)
		animation_player.call_deferred("play", "small ore break")
		await sound_effects.finished
		await get_tree().create_timer(0.6).timeout
		call_deferred("queue_free")

func _on_BigHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.special_ability == "fire":
		health -= Stats.FIRE_DEBUFF_DAMAGE
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-14, 14), randf_range(-8,8)))
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff" and _area.tool_name != "arrow":
		call_deferred("hit", _area.tool_name)
	if _area.tool_name == "arrow" or _area.tool_name == "fire projectile":
		_area.destroy()


func _on_small_hurt_box_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if area.special_ability == "fire":
		health -= Stats.FIRE_DEBUFF_DAMAGE
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-8, 8), randf_range(-8,8)))
	if area.tool_name != "lightning spell" and area.tool_name != "explosion spell" and area.tool_name != "arrow":
		call_deferred("hit", area.tool_name)
	if area.tool_name == "arrow" or area.tool_name == "fire projectile":
		area.destroy()
