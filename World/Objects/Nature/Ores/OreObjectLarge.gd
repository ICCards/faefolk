extends Node2D

onready var OreHitEffect = preload("res://World/Objects/Nature/Effects/OreHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var bigOreSprite = $BigOre
onready var smallOreSprite = $SmallOre
onready var animation_player = $AnimationPlayer
var rng = RandomNumberGenerator.new()

onready var world = get_tree().current_scene

var oreObject
var position_of_object
var variety
var showLargeOre


func initialize(varietyInput, posInput, isFullGrowth):
	variety = varietyInput
	oreObject = Images.returnOreObject(varietyInput)
	position_of_object = posInput
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
		$SmallMovementCollisionBox/CollisionShape2D.disabled = false
		$LargeOreOccupiedTiles/CollisionShape2D.set_deferred("disabled", true)
		bigOreSprite.visible = false
		smallOreSprite.visible = true


var bigOreHits: int = 4
func _on_BigHurtBox_area_entered(_area):
	rng.randomize()
	if bigOreHits == 0:
		PlayerFarmApi.set_farm_object_break(position_of_object)
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(0, 24))
		intitiateItemDrop(variety, Vector2(0, 4))
		animation_player.play("big_ore_break")
		$LargeOreOccupiedTiles/CollisionShape2D.set_deferred("disabled", true)

	if bigOreHits != 0:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-25, 25), rng.randi_range(-8, 32)))
		animation_player.play("big_ore_hit_right")
		bigOreHits = bigOreHits - 1

var smallOreHits: int = 2	
func _on_SmallHurtBox_area_entered(_area):
	rng.randomize()
	if smallOreHits == 0:
		PlayerFarmApi.remove_farm_object(position_of_object)
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 32))
		intitiateItemDrop(variety, Vector2(0, 28))
		animation_player.play("small_ore_break")
		yield($SoundEffects, "finished")
		queue_free()
		
	if smallOreHits != 0:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 24))
		animation_player.play("small_ore_hit_right")
		smallOreHits = smallOreHits - 1



## Effect functions
func intitiateItemDrop(item, pos):
	if item == "Stone" or item == "Cobblestone":
		item = "stone ore"
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item, 1)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos

func initiateOreHitEffect(ore, effect, pos):
	var oreHitEffect = OreHitEffect.instance()
	oreHitEffect.init(ore, effect)
	add_child(oreHitEffect)
	oreHitEffect.global_position = global_position + pos
	
	
