extends Node2D


onready var OreHitEffect = preload("res://World/Objects/Nature/Effects/OreHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var smallOreSprite = $SmallOre
onready var animation_player = $AnimationPlayer
var rng = RandomNumberGenerator.new()

var oreObject
var position_of_object
var variety
var health

func initialize(varietyInput, inputPos):
	variety = varietyInput
	oreObject = Images.returnOreObject(varietyInput)
	position_of_object = inputPos
	
func _ready():
	setTexture(oreObject)

func setTexture(ore):
	rng.randomize()
	smallOreSprite.texture = ore.mediumOres[rng.randi_range(0, 5)]
	
func PlayEffect(player_id):
	health -= 1
	if health >= 1:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 32))
		animation_player.play("small_ore_hit_right")
	else:
		Tiles.reset_valid_tiles(position_of_object)
		visible = false
		$SmallMovementCollisionBox/CollisionShape2D.disabled = true
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 42))
		yield($SoundEffects, "finished")
		queue_free()


func _on_SmallHurtBox_area_entered(_area):
	Stats.decrease_tool_health()
	rng.randomize()
	var data = {"id": name, "n": "ore"}
	Server.action("ON_HIT", data)
	health -= 1
	if health == 0:
		Tiles.reset_valid_tiles(position_of_object)
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 42))
		intitiateItemDrop(variety, Vector2(0, 40), 3)
		animation_player.play("small_ore_break")
		yield($SoundEffects, "finished")
		queue_free()
	if health != 0:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 32))
		animation_player.play("small_ore_hit_right")
		
		
## Effect functions
func intitiateItemDrop(item, pos, amount):
	rng.randomize()
	for i in range(amount):
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType("stone", 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), -36)

func initiateOreHitEffect(ore, effect, pos):
	var oreHitEffect = OreHitEffect.instance()
	oreHitEffect.init(ore, effect)
	add_child(oreHitEffect)
	oreHitEffect.global_position = global_position + pos + Vector2(0, -36)


func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
