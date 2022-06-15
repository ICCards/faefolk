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
var character

var swing_dict = {}
var swingActive = false
var direction = "down"

func _ready():
	setPlayerTexture("idle_" + direction)

func getCharacterById(player_id):
	Server._getCharacterById(player_id)


func MovePlayer(new_position, _direction):
	#print("new_position")
	if not new_position == position:
		print(new_position)
	direction = _direction.to_lower()
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
	
func swing():
	toolEquippedSprite.set_texture(Images.returnToolSprite('axe', direction.to_lower()))
	setPlayerTexture("swing_" + direction)
	animation_player.play("swing")
	yield(animation_player, "animation_finished" )
	toolEquippedSprite.texture = null
	animation_player.play("movement")
	
	
#	match direction:
#		"up":
#			toolEquippedSprite.set_texture(Images.returnToolSprite(tool_name, direction.to_lower()))

#func Swing():
#	for swing in swing_dict.keys():
#		if swing <= Server.client_clock:
#			swingActive = true
#			set_position(swing_dict[swing]["Position"])
#			setPlayerTexture("swing_" + swing_dict[swing]["Direction"])
#			toolEquippedSprite.set_texture(Images.returnToolSprite(swing_dict[swing]["ToolName"], swing_dict[swing]["Direction"]))
#			animation_player.play("swing")
#			yield(animation_player, "animation_finished")
#			swing_dict.erase(swing)
#			swingActive = false
#
