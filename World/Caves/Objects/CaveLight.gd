extends Node2D


var type

func _ready():
	match type:
		"blue":
			$PointLight2D.color = Color("00c3ff")
		"red":
			$PointLight2D.color = Color("ff9c9c")
		"yellow":
			$PointLight2D.color = Color("fcffcb")

