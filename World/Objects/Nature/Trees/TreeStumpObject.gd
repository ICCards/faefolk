extends Node2D

onready var stump_animation_player = $StumpAnimationPlayer 
onready var treeStumpSprite = $TreeSprites/TreeStump

onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var Player = get_node("/root/PlayerHomeFarm/Player")
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene
onready var treeTypes = ['A','B', 'C', 'D', 'E']
var treeObject
var position_of_object 

func initialize(variety, inputPos):
	position_of_object = inputPos
	treeObject = Images.returnTreeObject(variety)

func _ready():
	setTexture(treeObject)

func setTexture(tree):
	treeStumpSprite.texture = tree.largeStump


var stumpHealth: int = 2
func _on_StumpHurtBox_area_entered(_area):
	if stumpHealth == 0: 
		$SoundEffects.stream = Sounds.stump_break
		$SoundEffects.play()
		stump_animation_player.play("stump_destroyed")
		initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
		intitiateItemDrop("wood", Vector2(0, 0), 3)
		PlayerInventory.remove_farm_object(position_of_object)
		yield($SoundEffects, "finished")
		queue_free()
	
	elif stumpHealth != 0 :
		$SoundEffects.stream = Sounds.tree_hit[rng.randi_range(0,2)]
		$SoundEffects.play()
		if Player.get_position().x <= get_position().x:
			stump_animation_player.play("stump_hit_right")
			initiateTreeHitEffect(treeObject, "tree hit right", Vector2(0, 12))
			stumpHealth = stumpHealth - 1
		else: 
			initiateTreeHitEffect(treeObject, "tree hit left", Vector2(-24, 12))
			stump_animation_player.play("stump_hit_right")
			stumpHealth = stumpHealth - 1
			

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
		itemDrop.initItemDropType(item)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)


