extends Node2D

onready var big_ore_sprite: Sprite = $BigOre
onready var small_ore_sprite: Sprite = $SmallOre
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var rng = RandomNumberGenerator.new()

var ore_object
var location
var variety
var health
var large_break = false
var destroyed = false


func _ready():
	hide()
	ore_object = Images.returnOreObject(variety)
	setTexture(ore_object)


func setTexture(ore):
	rng.randomize()
	big_ore_sprite.texture = ore.largeOre
	small_ore_sprite.texture = ore.mediumOres[rng.randi_range(0, 5)]
	if health <= 40:
		$BigHurtBox/bigHurtBox.disabled = true
		$BigMovementCollisionBox/BigMovementBox.disabled = true
		$SmallHurtBox/smallHurtBox.disabled = false
		$SmallMovementCollisionBox/CollisionShape2D.disabled = false
		big_ore_sprite.visible = false
		small_ore_sprite.visible = true


func hit(tool_name):
	rng.randomize()
	health -= Stats.return_tool_damage(tool_name)
	if Server.generated_map["ore_large"].has(name):
		Server.generated_map["ore_large"][name]["h"] = health
		if health > 40:
			sound_effects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
			sound_effects.play()
			InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(rng.randi_range(-25, 25), rng.randi_range(-8, 32)))
			animation_player.play("big_ore_hit_right")
		elif not large_break:
			large_break = true
			sound_effects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
			sound_effects.play()
			InstancedScenes.initiateOreHitEffect(variety, "large ore break", position+Vector2(0, 24))
			var amount = Stats.return_item_drop_quantity(tool_name, "large ore")
			add_to_collection(variety, amount)
			if variety == "stone1" or variety == "stone2":
				InstancedScenes.intitiateItemDrop("stone", position+Vector2(0, 28), amount)
			else:
				InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 4), amount)
			animation_player.play("big_ore_break")
		elif health >= 1:
			sound_effects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
			sound_effects.play()
			InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(rng.randi_range(-10, 10), 32))
			animation_player.play("small_ore_hit_right")
		elif health <= 0 and not destroyed:
			destroyed = true
			Server.generated_map["ore_large"].erase(name)
			Tiles.add_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
			sound_effects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
			sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
			sound_effects.play()
			InstancedScenes.initiateOreHitEffect(variety, "ore destroyed", position+Vector2(rng.randi_range(-10, 10), 32))
			var amount = Stats.return_item_drop_quantity(tool_name, "small ore")
			add_to_collection(variety, amount)
			if variety == "stone1" or variety == "stone2":
				InstancedScenes.intitiateItemDrop("stone", position+Vector2(0, 28), amount)
			else:
				InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 28), amount)
			animation_player.play("small_ore_break")
			yield(sound_effects, "finished")
			yield(get_tree().create_timer(0.6), "timeout")
			queue_free()


func _on_BigHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		hit(_area.tool_name)
	if _area.special_ability == "fire buff":
		health -= Stats.FIRE_DEBUFF_DAMAGE
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-8, 8), rand_range(8,24)))


func _on_SmallHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "explosion spell":
		hit(_area.tool_name)
	if _area.special_ability == "fire":
		health -= Stats.FIRE_DEBUFF_DAMAGE
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-20, 20), rand_range(-8,16)))

func add_to_collection(type, amt):
	if type != "stone1" and type != "stone2":
		CollectionsData.resources[type] += amt
	else:
		CollectionsData.resources["stone"] += amt


func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
