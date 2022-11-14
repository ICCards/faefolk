extends Node2D


var type


func _ready():
	match type:
		"blue":
			$Light2D.color = Color("00c3ff")
		"red":
			$Light2D.color = Color("ff9c9c")
		"yellow":
			$Light2D.color = Color("fcffcb")

