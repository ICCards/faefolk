extends Node2D


onready var small_ore_sprite = $SmallOre
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var rng = RandomNumberGenerator.new()

var ore_object
var location
var variety
var health
var destroyed = false

func _ready():
	hide()
	setTexture()

func setTexture():
	rng.randomize()
	ore_object = Images.returnOreObject(variety)
	small_ore_sprite.texture = ore_object.mediumOres[rng.randi_range(0, 5)]
	
func PlayEffect(player_id):
	health -= 1
	if health >= 1:
		sound_effects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(rng.randi_range(-10, 10), 32))
		animation_player.play("small_ore_hit_right")
	else:
		Tiles.reset_valid_tiles(location)
		visible = false
		$SmallMovementCollisionBox/CollisionShape2D.disabled = true
		sound_effects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		InstancedScenes.initiateOreHitEffect(variety, "ore destroyed", position+Vector2(rng.randi_range(-10, 10), 42))
		yield(sound_effects, "finished")
		queue_free()


func hit(tool_name):
	rng.randomize()
	#var data = {"id": name, "n": "ore"}
	#Server.action("ON_HIT", data)
	health -= Stats.return_pickaxe_damage(tool_name)
	Server.generated_map["ore"][name]["h"] = health
	if health <= 0 and not destroyed:
		destroyed = true
		Server.generated_map["ore"].erase(name)
		Tiles.add_valid_tiles(location)
		sound_effects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		InstancedScenes.initiateOreHitEffect(variety, "ore destroyed", position)
		var amount = Stats.return_item_drop_quantity(tool_name, "small ore")
		add_to_collection(variety, amount)
		if variety == "stone1" or variety == "stone2":
			InstancedScenes.intitiateItemDrop("stone", position+Vector2(0, 12), amount)
		else:
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 12), amount)
		animation_player.play("small_ore_break")
		yield(sound_effects, "finished")
		yield(get_tree().create_timer(0.6), "timeout")
		queue_free()
	elif health >= 1:
		sound_effects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		InstancedScenes.initiateOreHitEffect(variety, "ore hit", position+Vector2(rng.randi_range(-10, 10), 8))
		animation_player.play("small_ore_hit_right")

func _on_SmallHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.tool_name != "lightning spell" and _area.tool_name != "explosion spell":
		hit(_area.tool_name)


func add_to_collection(type, amt):
	if type != "stone1" and type != "stone2":
		CollectionsData.resources[type] += amt
	else:
		CollectionsData.resources["stone"] += amt


func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
