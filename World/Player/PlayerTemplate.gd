extends KinematicBody2D

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped

onready var animation_player = $CompositeSprites/AnimationPlayer
const _character = preload("res://Global/Data/Characters.gd")
onready var character = _character.new()

var swing_dict = {}
var swingActive = false

func _ready():
	Server._getCharacter()

func _physics_process(delta):
	if not swing_dict == {}:
		Swing()


func MovePlayer(new_position, direction):
	if !swingActive:
		animation_player.play("movement")
		if new_position == position:
			setPlayerTexture("idle_" + direction)
		else: 
			setPlayerTexture("walk_" + direction)
			set_position(new_position)


func setPlayerTexture(var anim):
	bodySprite.set_texture(character.body_sprites[anim])
	armsSprite.set_texture(character.arms_sprites[anim])
	accessorySprite.set_texture(character.acc_sprites[anim])
	headAttributeSprite.set_texture(character.headAtr_sprites[anim])
	pantsSprite.set_texture(character.pants_sprites[anim])
	shirtsSprite.set_texture(character.shirts_sprites[anim])
	shoesSprite.set_texture(character.shoes_sprites[anim])

func Swing():
	for swing in swing_dict.keys():
		if swing <= Server.client_clock:
			swingActive = true
			set_position(swing_dict[swing]["Position"])
			setPlayerTexture("swing_" + swing_dict[swing]["Direction"])
			#toolEquippedSprite.set_texture(haracters.returnToolSprite(swing_dict[swing]["ToolName"], swing_dict[swing]["Direction"]))
			animation_player.play("swing")
			yield(animation_player, "animation_finished")
			swing_dict.erase(swing)
			swingActive = false
			
