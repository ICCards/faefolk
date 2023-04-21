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

func _ready():
	Tiles.remove_valid_tiles(location)
	setTreeBranchType()

func remove_from_world():
	$BranchHurtBox.call_deferred("queue_free")
	$MovementCollisionBox.call_deferred("queue_free")
	call_deferred("queue_free")

func setTreeBranchType():
	$Log.texture = load("res://Assets/Images/tree_sets/branch_objects/"+ str(variety) +".png")
	if variety == 1 or variety == 7 or variety == 9:
		$Break.offset = Vector2i(-6,-5)
	elif variety == 2:
		$Break.offset = Vector2i(-6,-6)
	elif variety == 3:
		$Break.offset = Vector2i(-5,-6)
	elif variety == 4 or variety == 8:
		$Break.offset = Vector2i(-6,-4)
	elif variety == 5 or variety == 10 or variety == 11 or variety == 12:
		$Break.offset = Vector2i(-5,-5)
		

func destroy(data):
	if not destroyed:
		destroyed = true
#		if MapData.world["log"].has(name):
#			MapData.world["log"].erase(name)
		$Log.call_deferred("hide")
		$Break.call_deferred("show")
		$Break.call_deferred("play",str(variety))
		Tiles.add_valid_tiles(location)
		sound_effects.set_deferred("stream", Sounds.stump_break) 
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12)) 
		sound_effects.call_deferred("play")
		animation_player.call_deferred("play", "break")
		if data["player_id"] == Server.player_node.name:
			var amt = Stats.return_item_drop_quantity(data["tool_name"], "branch")
			PlayerData.player_data["collections"]["resources"]["wood"] += amt
			InstancedScenes.intitiateItemDrop("wood",position,amt)
		await get_tree().create_timer(1.2).timeout
		call_deferred("queue_free")

func _on_BranchHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	if _area.special_ability == "fire buff":
		InstancedScenes.initiateExplosionParticles(position+Vector2(randf_range(-16,16), randf_range(-16,16)))
	if _area.tool_name != "lightning spell" and _area.tool_name != "lightning spell debuff":
		get_parent().rpc_id(1,"nature_object_hit",Server.player_node.name,"log",name,location,_area.tool_name)
		#call_deferred("hit", _area.tool_name)


