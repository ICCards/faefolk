extends Node2D

onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump

onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene
onready var treeTypes = ['A','B', 'C', 'D', 'E']
var treeObject
var position_of_object 
var hit_dir
var health

func initialize(variety, inputPos):
	position_of_object = inputPos
	treeObject = Images.returnTreeObject(variety)

func _ready():
	setTexture(treeObject)


func PlayEffect(player_id):
	health -= 1
	if get_node("/root/World/Players/" + str(player_id)).get_position().x < get_position().x:
		hit_dir = "right"
	else:
		hit_dir = "left"
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
		
func setTexture(tree):
	treeStumpSprite.texture = tree.largeStump


var stumpHealth: int = 2
func _on_StumpHurtBox_area_entered(_area):
	var data = {"id": name, "n": "stump"}
	Server.action("ON_HIT", data)
	health -= 1
	if health <= 0: 
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
		if get_node("/root/World/Players/" + str(Server.player_id)).get_position().x <= get_position().x:
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


