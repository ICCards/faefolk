extends Node2D


func set_active():
	$Light.enabled = true
	$HoldingTorch.show()
	
func set_inactive():
	$Light.enabled = false
	$HoldingTorch.hide()
	
