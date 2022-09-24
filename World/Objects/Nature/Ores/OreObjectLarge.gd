extends Node2D

onready var OreBreak = preload("res://World/Objects/Nature/Effects/OreBreak.tscn")
onready var OreHitEffect = preload("res://World/Objects/Nature/Effects/OreHitEffect.tscn")
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
onready var bigOreSprite = $BigOre
onready var smallOreSprite = $SmallOre
onready var animation_player = $AnimationPlayer
var rng = RandomNumberGenerator.new()


var oreObject
var loc
var variety
var health
var large_break = false
var small_break = false


func initialize(_variety, _loc):
	variety = _variety
	oreObject = Images.returnOreObject(variety)
	loc = _loc


func _ready():
	setTexture(oreObject)
	
func PlayEffect(player_id):
	health -= 1
	if health >= 4:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-25, 25), rng.randi_range(-8, 32)))
		animation_player.play("big_ore_hit_right")
	elif health == 3:
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(0, 24))
		animation_player.play("big_ore_break")
	elif health >= 1:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 24))
		animation_player.play("small_ore_hit_right")
	elif health == 0:
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 32))
		animation_player.play("small_ore_break")
		yield($SoundEffects, "finished")
		queue_free()


func setTexture(ore):
	rng.randomize()
	bigOreSprite.texture = ore.largeOre
	smallOreSprite.texture = ore.mediumOres[rng.randi_range(0, 5)]
	if health <= 3:
		$BigHurtBox/bigHurtBox.disabled = true
		$BigMovementCollisionBox/BigMovementBox.disabled = true
		$SmallHurtBox/smallHurtBox.disabled = false
		$SmallMovementCollisionBox/CollisionShape2D.disabled = false
		$LargeOreOccupiedTiles/CollisionShape2D.set_deferred("disabled", true)
		bigOreSprite.visible = false
		smallOreSprite.visible = true



func _on_BigHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	rng.randomize()
	var data = {"id": name, "n": "large_ore"}
	Server.action("ON_HIT", data)
	deduct_health(_area.tool_name)
	if health >= 40:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-25, 25), rng.randi_range(-8, 32)))
		animation_player.play("big_ore_hit_right")
	elif not large_break:
		large_break = true
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore break", Vector2(0, 24))
		intitiateItemDrop(variety, Vector2(0, 4), 5)
		animation_player.play("big_ore_break")
		$LargeOreOccupiedTiles/CollisionShape2D.set_deferred("disabled", true)



func _on_SmallHurtBox_area_entered(_area):
	if _area.name == "AxePickaxeSwing":
		Stats.decrease_tool_health()
	rng.randomize()
	var data = {"id": name, "n": "large_ore"}
	Server.action("ON_HIT", data)
	deduct_health(_area.tool_name)
	if health <= 0 and not small_break:
		small_break = true
		Tiles.reset_valid_tiles(loc, "large ore")
		$SoundEffects.stream = Sounds.ore_break[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		oreBreakEffect()
		initiateOreHitEffect(oreObject, "ore break", Vector2(rng.randi_range(-10, 10), 32))
		intitiateItemDrop(variety, Vector2(0, 28), 3)
		animation_player.play("small_ore_break")
		yield($SoundEffects, "finished")
		yield(get_tree().create_timer(0.6), "timeout")
		queue_free()
	elif health >= 1:
		$SoundEffects.stream = Sounds.ore_hit[rng.randi_range(0, 2)]
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		$SoundEffects.play()
		initiateOreHitEffect(oreObject, "ore hit", Vector2(rng.randi_range(-10, 10), 24))
		animation_player.play("small_ore_hit_right")


func deduct_health(tool_name):
	match tool_name:
		"wood pickaxe":
			health -= Stats.WOOD_TOOL_DAMAGE
		"stone pickaxe":
			health -= Stats.STONE_TOOL_DAMAGE
		"bronze pickaxe":
			health -= Stats.BRONZE_TOOL_DAMAGE
		"iron pickaxe":
			health -= Stats.IRON_TOOL_DAMAGE
		"gold pickaxe":
			health -= Stats.GOLD_TOOL_DAMAGE



## Effect functions
func intitiateItemDrop(item, pos, amount):
	rng.randomize()
	for i in range(amount):
		var itemDrop = ItemDrop.instance()
		itemDrop.initItemDropType("stone", 1)
		get_parent().call_deferred("add_child", itemDrop)
		itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)

func initiateOreHitEffect(ore, effect, pos):
	var oreHitEffect = OreHitEffect.instance()
	oreHitEffect.init(ore, effect)
	add_child(oreHitEffect)
	oreHitEffect.global_position = global_position + pos
	
func oreBreakEffect():
	var oreBreak = OreBreak.instance()
	oreBreak.variety = variety
	add_child(oreBreak)
	oreBreak.global_position = global_position + Vector2(0,8)


func _on_VisibilityNotifier2D_screen_entered():
	visible = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
