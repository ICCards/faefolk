extends Node2D

onready var OreHitEffect = preload("res://Globals/Effects/OreHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var bigOreSprite = $BigOre
onready var smallOreSprite = $SmallOre
onready var animation_player = $AnimationPlayer
var rng = RandomNumberGenerator.new()
onready var world = get_tree().current_scene


var oreObject
var pos
var variety
var showLargeOre


func initialize(varietyInput, posInput, isFullGrowth):
	variety = varietyInput
	oreObject = Images.returnOreObject(varietyInput)
	pos = posInput
	showLargeOre = isFullGrowth

func _ready():
	setTexture(oreObject)

func setTexture(ore):
	rng.randomize()
	bigOreSprite.texture = ore.largeOre
	smallOreSprite.texture = ore.mediumOres[rng.randi_range(0, 5)]
	if !showLargeOre:
		$BigHurtBox/bigHurtBox.disabled = true
		$BigMovementCollisionBox/BigMovementBox.disabled = true
		$SmallHurtBox/smallHurtBox.disabled = false
		$SmallMovementCollisionBox/SmallMovementBox.disabled = false
		bigOreSprite.visible = false
		smallOreSprite.visible = true


var bigOreHits: int = 4
func _on_BigHurtBox_area_entered(_area):
	rng.randomize()
	if bigOreHits == 0:
		PlayerInventory.set_farm_object_break(pos)
		$SoundEffects.stream = Global.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 40))
		intitiateItemDrop(variety, Vector2(0, 10))
		animation_player.play("big_ore_break")

		
	if bigOreHits != 0:
		$SoundEffects.stream = Global.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-25, 25), rng.randi_range(0, 40)))
		animation_player.play("big_ore_hit_right")
		bigOreHits = bigOreHits - 1

var smallOreHits: int = 2	
func _on_SmallHurtBox_area_entered(_area):
	rng.randomize()
	if smallOreHits == 0:
		$SoundEffects.stream = Global.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 50))
		intitiateItemDrop(variety, Vector2(0, 40))
		animation_player.play("small_ore_break")
		yield($SoundEffects, "finished")
		PlayerInventory.remove_farm_object(pos)
		queue_free()
	if smallOreHits != 0:
		$SoundEffects.stream = Global.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 40))
		animation_player.play("small_ore_hit_right")
		smallOreHits = smallOreHits - 1



## Effect functions
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item)
	world.call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos

func initiateOreHitEffect(ore, effect, pos):
	var oreHitEffect = OreHitEffect.instance()
	oreHitEffect.init(ore, effect)
	world.add_child(oreHitEffect)
	oreHitEffect.global_position = global_position + pos
	
	
