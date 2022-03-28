extends Node2D

onready var Player = get_node("/root/World/YSort/Player")
onready var OreHitEffect = preload("res://Globals/Effects/OreHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var bigOreSprite = $BigOre
onready var smallOreSprite = $SmallOre
onready var animation_player = $AnimationPlayer
var rng = RandomNumberGenerator.new()
onready var oreTypes = ['Red gem', 'Green gem', 'Dark blue gem', 'Cyan gem', 'Gold ore', 'Iron ore', 'Stone']
var oreObject
onready var world = get_tree().current_scene


func _ready():
	rng.randomize()
	oreTypes.shuffle()
	oreObject = Images.returnOreObject(oreTypes[0])
	setTexture(oreObject)

var bigOreHits: int = 4
func _on_BigHurtBox_area_entered(area):
	rng.randomize()
	if bigOreHits == 0:
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreObject, "ore break")
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position + Vector2(rng.randi_range(-10, 10), 40)
		
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(oreTypes[0])
		world.call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + Vector2(0, 20)

		animation_player.play("big_ore_break")
	if bigOreHits != 0:
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreObject, "ore hit")
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position + Vector2(rng.randi_range(-25, 25), rng.randi_range(0, 40))
		animation_player.play("big_ore_hit_right")
		bigOreHits = bigOreHits - 1

var smallOreHits: int = 2	
func _on_SmallHurtBox_area_entered(area):
	rng.randomize()
	if smallOreHits == 0:
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreObject, "ore break")
		world.call_deferred("add_child", oreHitEffect)
		oreHitEffect.global_position = global_position + Vector2(rng.randi_range(-10, 10), 50)

		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType(oreTypes[0])
		world.call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + Vector2(0, 40)
		 
		animation_player.play("small_ore_break")
	if smallOreHits != 0:
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreObject, "ore hit")
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position + Vector2(rng.randi_range(-10, 10), 40)
		animation_player.play("small_ore_hit_right")
		smallOreHits = smallOreHits - 1


		
func setTexture(ore):
	bigOreSprite.texture = ore.largeOre
	smallOreSprite.texture = ore.mediumOres[rng.randi_range(0, 5)]
