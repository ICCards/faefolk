extends Node2D


onready var bodySprite = $Body
onready var armsSprite = $Arms
onready var accessorySprite = $Accessory
onready var headAttributeSprite = $HeadAtr
onready var pantsSprite = $Pants
onready var shirtsSprite = $Shirts
onready var shoesSprite = $Shoes
onready var toolEquippedSprite = $ToolEquipped


func set_player_animation(_character, _anim, _tool):
	bodySprite.set_texture(_character.body_sprites[_anim])
	armsSprite.set_texture(_character.arms_sprites[_anim])
	accessorySprite.set_texture(_character.acc_sprites[_anim])
	headAttributeSprite.set_texture(_character.headAtr_sprites[_anim])
	pantsSprite.set_texture(_character.pants_sprites[_anim])
	shirtsSprite.set_texture(_character.shirts_sprites[_anim])
	shoesSprite.set_texture(_character.shoes_sprites[_anim])
	toolEquippedSprite.set_texture(Images.returnToolSprite(_tool, _anim))

