extends Node2D

onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump
onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var valid_tiles = get_node("/root/World/WorldNavigation/ValidTiles")
onready var treeTypes = ['A','B', 'C', 'D', 'E']
var rng = RandomNumberGenerator.new()
var treeObject
var loc 
var health

func initialize(variety, _loc):
	loc = _loc
	treeObject = Images.returnTreeObject(variety)

func _ready():
	setTexture(treeObject)
	
func setTexture(tree):
	treeStumpSprite.texture = tree.largeStump

func PlayEffect(player_id):
	health -= 1
	var hit_dir
	if get_node("/root/World/Players/" + str(player_id) + "/" +  str(player_id)).get_position().x < get_position().x:
		hit_dir = "left"
	else:
		hit_dir = "right"
	if health >= 1:
		$SoundEffects.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		if hit_dir == "right":
			stump_animation_player.play("stump hit right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump hit right")
	else:
		$SoundEffects.stream = Sounds.stump_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		stump_animation_player.play("stump destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
		Tiles.reset_valid_tiles(loc, "stump")
		yield($SoundEffects, "finished")
		queue_free()
		

func _on_StumpHurtBox_area_entered(_area):
	Stats.decrease_tool_health()
	var data = {"id": name, "n": "stump"}
	Server.action("ON_HIT", data)
	health -= 1
	if health <= 0: 
		Tiles.reset_valid_tiles(loc, "stump")
		$SoundEffects.stream = Sounds.stump_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		stump_animation_player.play("stump destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
		intitiateItemDrop("wood", Vector2(0, 0), 3)
		yield($SoundEffects, "finished")
		queue_free()
	else:
		$SoundEffects.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		if get_node("/root/World/Players/" + str(Server.player_id) + "/" +  str(Server.player_id)).get_position().x <= get_position().x:
			stump_animation_player.play("stump hit right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump hit right")


### Effect functions		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos
	
func intitiateItemDrop(item, pos, amt):
	for _i in range(amt):
		rng.randomize()
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item, 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
