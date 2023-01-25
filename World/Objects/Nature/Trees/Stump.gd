extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer 
onready var tree_stump_sprite: Sprite = $TreeSprites/TreeStump
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var rng = RandomNumberGenerator.new()

var tree_object
var location 
var health
var variety
var destroyed: bool = false

func _ready():
	visible = false
	call_deferred("setTexture", tree_object)
	
func setTexture(tree):
	tree_stump_sprite.set_deferred("texture", load("res://Assets/Images/tree_sets/"+ variety +"/large stump.png"))

func hit(tool_name):
	health -= Stats.return_tool_damage(tool_name)
	if MapData.world["stump"].has(name):
		MapData.world["stump"][name]["h"] = health
	if health > 0:
		sound_effects.set_deferred("stream", Sounds.tree_hit[rng.randi_range(0,2)])
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		if Server.player_node.get_position().x <= get_position().x:
			animation_player.call_deferred("play", "stump hit right")
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit right", position+Vector2(0, 12))
		else: 
			InstancedScenes.initiateTreeHitEffect(variety, "tree hit left", position+Vector2(-24, 12))
			animation_player.call_deferred("play", "stump hit right")
	elif not destroyed:
		destroyed = true
		if MapData.world["stump"].has(name):
			MapData.world["stump"].erase(name)
		Tiles.add_valid_tiles(location+Vector2(-1,0), Vector2(2,2))
		sound_effects.set_deferred("stream", Sounds.stump_break)
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")
		animation_player.call_deferred("play", "stump destroyed")
		InstancedScenes.initiateTreeHitEffect(variety, "trunk break", position+Vector2(-16, 32))
		var amt = Stats.return_item_drop_quantity(tool_name, "stump")
		PlayerData.player_data["collections"]["resources"]["wood"] += amt
		InstancedScenes.intitiateItemDrop("wood", position, amt)
		yield(sound_effects, "finished")
		queue_free()


func _on_StumpHurtbox_area_entered(area):
	if area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		call_deferred("hit", area.tool_name)
	if area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(rand_range(-16,16), rand_range(-18,12)))
		health -= Stats.FIRE_DEBUFF_DAMAGE


func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("show")
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("hide")

