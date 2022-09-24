extends Node2D

onready var branch = $Branch

onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()

var randomNum
var treeObject
var loc
var health

func initialize(variety, _loc):
	randomNum = variety
	loc = _loc

func _ready():
	setTreeBranchType(randomNum)
	
func PlayEffect(player_id):
	Tiles.reset_valid_tiles(loc)
	$SoundEffects.stream = Sounds.stump_break
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func setTreeBranchType(num):
	if num <= 2:
		treeObject = Images.returnTreeObject('D')
	elif num <= 5:
		treeObject = Images.returnTreeObject('B')
	elif num <= 8:
		treeObject = Images.returnTreeObject('A')
	else:
		treeObject = Images.returnTreeObject('C')
	$Branch.texture = Images.tree_branch_objects[num]

func _on_BranchHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	Tiles.reset_valid_tiles(loc, "stump")
	var data = {"id": name, "n": "log"}
	Server.action("ON_HIT", data)
	$SoundEffects.stream = Sounds.stump_break
	$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	$SoundEffects.play()
	$AnimationPlayer.play("break")
	initiateTreeHitEffect(treeObject, "trunk break", Vector2(-16, 32))
	intitiateItemDrop("wood", Vector2(0, 0), Stats.return_item_drop_quantity(_area.tool_name, "branch"))
	yield(get_tree().create_timer(1.2), "timeout")
	queue_free()


### Effect functions		
func initiateTreeHitEffect(tree, effect, pos):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(tree, effect)
	add_child(trunkHitEffect)
	trunkHitEffect.global_position = global_position + pos 
	
func intitiateItemDrop(item, pos, qt):
	rng.randomize()
	for i in range(qt):
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item, 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
