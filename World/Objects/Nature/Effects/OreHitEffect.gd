extends Node2D

@onready var oreChip1: Sprite2D = $OreChips/OreChip1
@onready var oreChip2: Sprite2D = $OreChips/OreChip2
@onready var oreChip3: Sprite2D = $OreChips/OreChip3
@onready var oreChip4: Sprite2D = $OreChips/OreChip4
@onready var oreChip5: Sprite2D = $OreChips/OreChip5
@onready var oreChip6: Sprite2D = $OreChips/OreChip6
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var effect_type
var variety

func _ready():
	rng.randomize()
	setTexture()
	if effect_type == "ore hit":
		animation_player.play("ore hit " + str(rng.randi_range(1, 2)))
	elif effect_type == "large ore break":
		animation_player.play("large ore break")
	elif effect_type == "small ore break":
		animation_player.play("small ore break")
#		play_break_anim()
	await animation_player.animation_finished
	queue_free()


#func play_break_anim():
#	if variety == "stone2":
#		$Parts.modulate = Color("c29c6b")
#	elif variety == "iron ore":
#		$Parts.modulate = Color("c3b779")
#	elif variety == "bronze ore":
#		$Parts.modulate = Color("946c38")
#	elif variety == "gold ore":
#		$Parts.modulate = Color("c79c3e")
#	$Smoke.show()
#	$Parts.show()
#	$Smoke.play("break")
#	$Parts.play("break")
#	await $Parts.animation_finished


func setTexture():
	oreChip1.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	oreChip2.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	oreChip3.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	oreChip4.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	oreChip5.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	oreChip6.texture = load("res://Assets/Images/Ores/"+ variety  +"/chip.png")
	if variety == "stone2":
		$Parts.modulate = Color("c29c6b")
	elif variety == "iron ore":
		$Parts.modulate = Color("c3b779")
	elif variety == "bronze ore":
		$Parts.modulate = Color("946c38")
	elif variety == "gold ore":
		$Parts.modulate = Color("c79c3e")

