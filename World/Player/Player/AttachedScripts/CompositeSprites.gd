extends Node2D


onready var bodySprite = $Body
onready var legsSprite = $Legs
onready var armsSprite = $Arms
onready var accessorySprite = $Accessory
onready var headAttributeSprite = $HeadAtr
onready var pantsSprite = $Pants
onready var shirtsSprite = $Shirts
onready var shoesSprite = $Shoes
onready var toolEquippedSprite = $ToolEquipped


func set_player_animation(_character, _anim, var _tool = ""):
	bodySprite.set_texture(_character.body_sprites[returnAdjustedAnimTop(_anim)])
	legsSprite.set_texture(_character.leg_sprites[returnAdjustedAnimBottom(_anim)])
	armsSprite.set_texture(_character.arms_sprites[returnAdjustedAnimTop(_anim)])
	accessorySprite.set_texture(_character.acc_sprites[returnAdjustedAnimTop(_anim)])
	headAttributeSprite.set_texture(_character.headAtr_sprites[returnAdjustedAnimTop(_anim)])
	pantsSprite.set_texture(_character.pants_sprites[returnAdjustedAnimBottom(_anim)])
	shirtsSprite.set_texture(_character.shirts_sprites[returnAdjustedAnimTop(_anim)])
	shoesSprite.set_texture(_character.shoes_sprites[returnAdjustedAnimBottom(_anim)])
	toolEquippedSprite.set_texture(Images.returnToolSprite(_tool, returnAdjustedAnimTop(_anim)))

func returnAdjustedAnimTop(_anim):
	if _anim == "draw_up_down" or _anim == "draw_up_up" or _anim == "draw_up_left" or _anim == "draw_up_right":
		return "draw_up"
	if _anim == "draw_down_down" or _anim == "draw_down_up" or _anim == "draw_down_left" or _anim == "draw_down_right":
		return "draw_down"
	if _anim == "draw_right_down" or _anim == "draw_right_up" or _anim == "draw_right_left" or _anim == "draw_right_right":
		return "draw_right"
	if _anim == "draw_left_down" or _anim == "draw_left_up" or _anim == "draw_left_left" or _anim == "draw_left_right":
		return "draw_left"
	return _anim

func returnAdjustedAnimBottom(_anim):
	if _anim == "draw_down":
		return "magic_cast_down"
	if _anim == "draw_up":
		return "magic_cast_up"
	if _anim == "draw_right":
		return "magic_cast_right"
	if _anim == "draw_left":
		return "magic_cast_left"
	if _anim == "draw_up_down":
		return "magic_cast_up_down"
	if _anim == "draw_up_up":
		return "magic_cast_up_up"
	if _anim == "draw_up_right":
		return "magic_cast_up_right"
	if _anim == "draw_up_left":
		return "magic_cast_up_left"
	if _anim == "draw_down_down":
		return "magic_cast_down_down"
	if _anim == "draw_down_up":
		return "magic_cast_down_up"
	if _anim == "draw_down_right":
		return "magic_cast_down_right"
	if _anim == "draw_down_left":
		return "magic_cast_down_left"
	if _anim == "draw_right_down":
		return "magic_cast_right_down"
	if _anim == "draw_right_up":
		return "magic_cast_right_up"
	if _anim == "draw_right_right":
		return "magic_cast_right_right"
	if _anim == "draw_right_left":
		return "magic_cast_right_left"
	if _anim == "draw_left_down":
		return "magic_cast_left_down"
	if _anim == "draw_left_up":
		return "magic_cast_left_up"
	if _anim == "draw_left_right":
		return "magic_cast_left_right"
	if _anim == "draw_left_left":
		return "magic_cast_left_left"
	return _anim

