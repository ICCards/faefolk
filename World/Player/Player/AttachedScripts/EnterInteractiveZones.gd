extends Node2D

func _on_ChestArea_area_entered(area):
	PlayerInventory.chest_id = area.name
func _on_ChestArea_area_exited(area):
	PlayerInventory.chest_id = null

func _on_WorkbenchArea_area_entered(area):
	PlayerInventory.workbench_id = area.name
func _on_WorkbenchArea_area_exited(area):
	PlayerInventory.workbench_id = null

func _on_StoveArea_area_entered(area):
	PlayerInventory.stove_id = area.name
func _on_StoveArea_area_exited(area):
	PlayerInventory.stove_id = null

func _on_GrainMillArea_area_entered(area):
	PlayerInventory.grain_mill_id = area.name
func _on_GrainMillArea_area_exited(area):
	PlayerInventory.grain_mill_id = null

func _on_SleepingBag_area_entered(area):
	PlayerInventory.is_inside_sleeping_bag_area = true
func _on_SleepingBag_area_exited(area):
	PlayerInventory.is_inside_sleeping_bag_area = false


func _on_FurnaceArea_area_entered(area):
	PlayerInventory.furnace_node = area
func _on_FurnaceArea_area_exited(area):
	PlayerInventory.furnace_node = null
