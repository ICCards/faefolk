extends Node2D


onready var small_ore_sprite = $SmallOre
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
var rng = RandomNumberGenerator.new()

var ore_object
var location
var variety
var health
var ore_break = false


func _ready():
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


func _on_SmallHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	rng.randomize()
	var data = {"id": name, "n": "ore"}
	Server.action("ON_HIT", data)
	health -= Stats.return_pickaxe_damage(_area.tool_name)
	if health <= 0 and not ore_break:
		ore_break = true
		Tiles.reset_valid_tiles(location)
		sound_effects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		InstancedScenes.initiateOreHitEffect(variety, "ore destroyed", position+Vector2(rng.randi_range(-10, 10), 0))
		if variety == "stone1" or variety == "stone2":
			InstancedScenes.intitiateItemDrop("stone", position+Vector2(0, 12), Stats.return_item_drop_quantity(_area.tool_name, "small ore"))
		else:
			InstancedScenes.intitiateItemDrop(variety, position+Vector2(0, 12), Stats.return_item_drop_quantity(_area.tool_name, "small ore"))
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


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
func _on_VisibilityNotifier2D_screen_exited():
	visible = false
