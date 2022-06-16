extends Node2D



func _ready():
	$wood_box.modulate = Color(1, 1, 1, 0.5)


func _on_wood_box_gui_input(event):
	if event is InputEventMouseMotion:
		print('entered wood box')
