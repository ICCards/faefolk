extends Node2D

func _on_ChestArea_area_entered(area):
	PlayerInventory.chest_id = area.name
	PlayerInventory.is_inside_chest_area = true

func _on_ChestArea_area_exited(area):
	PlayerInventory.is_inside_chest_area = false

func _on_WorkbenchArea_area_entered(area):
	PlayerInventory.is_inside_workbench_area = true

func _on_WorkbenchArea_area_exited(area):
	PlayerInventory.is_inside_workbench_area = false

func _on_StoveArea_area_entered(area):
	PlayerInventory.is_inside_stove_area = true

func _on_StoveArea_area_exited(area):
	PlayerInventory.is_inside_stove_area = false

func _on_GrainMillArea_area_entered(area):
	PlayerInventory.is_inside_grain_mill_area = true

func _on_GrainMillArea_area_exited(area):
	PlayerInventory.is_inside_grain_mill_area = false

func _on_SleepingBag_area_entered(area):
	PlayerInventory.is_inside_sleeping_bag_area = true

func _on_SleepingBag_area_exited(area):
	PlayerInventory.is_inside_sleeping_bag_area = false
