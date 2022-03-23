extends Node2D

onready var Player = get_node("/root/World/YSort/Player/Player")
onready var OreHitEffect = preload("res://Globals/Effects/OreHitEffect.tscn")

onready var bigOreSprite = $BigOre
onready var smallOreSprite = $SmallOre
onready var AnimPlayer = $AnimationPlayer
var rng = RandomNumberGenerator.new()
onready var oreTypes = ['red', 'green', 'dark blue', 'cyan', 'gold', 'iron', 'beige stone', 'grey stone']
var oreType
func _ready():
	rng.randomize()
	oreTypes.shuffle()
	oreType = oreTypes[0]
	setOreType(oreType)

var bigOreHits: int = 4
func _on_BigHurtBox_area_entered(area):
	if (bigOreHits == 0):
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreType, "big ore break")
		var world = get_tree().current_scene
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position
		AnimPlayer.play("big_ore_break")
	if (bigOreHits != 0):
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreType, "big ore hit")
		var world = get_tree().current_scene
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position
		AnimPlayer.play("big_ore_hit_right")
		bigOreHits = bigOreHits - 1

var smallOreHits: int = 2	
func _on_SmallHurtBox_area_entered(area):
	if (smallOreHits == 0):
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreType, "small ore break")
		var world = get_tree().current_scene
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position
		AnimPlayer.play("small_ore_break")
	if (smallOreHits != 0):
		var oreHitEffect = OreHitEffect.instance()
		oreHitEffect.init(oreType, "big ore hit")
		var world = get_tree().current_scene
		world.add_child(oreHitEffect)
		oreHitEffect.global_position = global_position
		AnimPlayer.play("small_ore_hit_right")
		smallOreHits = smallOreHits - 1


		
func setOreType(ore):
	if (ore == 'red'):
		bigOreSprite.texture = Images.redOreLarge
		smallOreSprite.texture = Images.redOreMediums[rng.randi_range(0, 5)]
	if (ore == 'green'):
		bigOreSprite.texture = Images.greenOreLarge
		smallOreSprite.texture = Images.greenOreMediums[rng.randi_range(0, 5)]
	if (ore == 'dark blue'):
		bigOreSprite.texture = Images.darkBlueOreLarge
		smallOreSprite.texture = Images.darkBlueOreMediums[rng.randi_range(0, 5)]
	if (ore == 'cyan'):
		bigOreSprite.texture = Images.cyanOreLarge
		smallOreSprite.texture = Images.cyanOreMediums[rng.randi_range(0, 5)]
	if (ore == 'gold'):
		bigOreSprite.texture = Images.goldOreLarge
		smallOreSprite.texture = Images.goldOreMediums[rng.randi_range(0, 5)]
	if (ore == 'iron'):
		bigOreSprite.texture = Images.ironOreLarge
		smallOreSprite.texture = Images.ironOreMediums[rng.randi_range(0, 5)]
	if (ore == 'beige stone'):
		bigOreSprite.texture = Images.stoneOreLarge
		smallOreSprite.texture = Images.stoneOreMediums[rng.randi_range(0, 5)]
	if (ore == 'grey stone'):
		bigOreSprite.texture = Images.cobblestoneOreLarge
		smallOreSprite.texture = Images.cobblestoneOreMediums[rng.randi_range(0, 5)]
