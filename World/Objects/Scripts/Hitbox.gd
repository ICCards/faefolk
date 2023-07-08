extends Area2D


var tool_name = ""
var special_ability = ""
var knockback_vector = Vector2.ZERO
var id = ""

func destroy():
	get_parent().destroy()
