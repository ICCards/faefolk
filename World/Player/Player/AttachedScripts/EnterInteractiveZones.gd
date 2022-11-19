extends Node2D

func _on_Area2D_area_entered(area):
	get_node("../../Camera2D/UserInterface").object_name = area.object_name
	get_node("../../Camera2D/UserInterface").object_level = area.object_level
	get_node("../../Camera2D/UserInterface").object_id = area.name

func _on_Area2D_area_exited(area):
	get_node("../../Camera2D/UserInterface").object_name = null
	get_node("../../Camera2D/UserInterface").object_level = null
	get_node("../../Camera2D/UserInterface").object_id = null



