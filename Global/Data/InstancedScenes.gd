extends Node

onready var Bird = preload("res://World/Animals/BirdFlyingFromTree.tscn")
onready var LeavesFallEffect = preload("res://World/Objects/Nature/Effects/LeavesFallingEffect.tscn")
onready var TrunkHitEffect = preload("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")

onready var OreHitEffect = preload("res://World/Objects/Nature/Effects/OreHitEffect.tscn")

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func intitiateItemDrop(item_name: String, pos: Vector2, amount: int):
	for _i in range(amount):
		rng.randomize()
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(item_name)
		Server.world.call_deferred("add_child", itemDrop)
		itemDrop.global_position = pos + Vector2(rng.randi_range(-12, 12), rng.randi_range(-6, 6))

func initiateInventoryItemDrop(item: Array, pos: Vector2):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item[0], item[1], item[2])
	Server.world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = pos + Vector2(rng.randi_range(-32, 32), rng.randi_range(-24, 24))


### Trees ###
func initiateLeavesFallingEffect(variety: String, pos: Vector2):
	if Server.world:
		var adjusted_leaves_falling_pos = Vector2.ZERO
		match variety:
			"D":
				adjusted_leaves_falling_pos = Vector2(0, 50)
			"B":
				adjusted_leaves_falling_pos = Vector2(0, 25)
			_: 
				adjusted_leaves_falling_pos = Vector2(0, 0)
		var leavesEffect = LeavesFallEffect.instance()
		leavesEffect.initLeavesEffect(variety)
		Server.world.call_deferred("add_child", leavesEffect)
		leavesEffect.global_position = adjusted_leaves_falling_pos + pos

func initiateTreeHitEffect(variety: String, effect_type: String, pos: Vector2):
	var trunkHitEffect = TrunkHitEffect.instance()
	trunkHitEffect.init(variety, effect_type)
	Server.world.add_child(trunkHitEffect)
	trunkHitEffect.global_position = pos

func initiateBirdEffect(pos: Vector2):
	if Util.chance(33):
		if Util.chance(50):
			rng.randomize()
			var bird = Bird.instance()
			bird.fly_position = pos + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
			Server.world.call_deferred("add_child", bird)
			bird.global_position = pos + Vector2(0, -120)
		else:
			for i in range(2):
				rng.randomize()
				var bird = Bird.instance()
				bird.fly_position = pos + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
				Server.world.call_deferred("add_child", bird)
				bird.global_position = pos + Vector2(0, -120)

### Ores ###

func initiateOreHitEffect(variety: String, effect_type: String, pos: Vector2):
	var oreHitEffect = OreHitEffect.instance()
	oreHitEffect.variety = variety
	oreHitEffect.effect_type = effect_type
	Server.world.add_child(oreHitEffect)
	oreHitEffect.global_position = pos
	

