extends Node2D



func _ready():
	PlayerStats.connect("energy_changed", self, "set_stat_bars")
	set_stat_bars()
	
func set_stat_bars():
	$EnergyUI/EnergyPgBar.max_value = PlayerStats.energy_maximum
	$EnergyUI/EnergyPgBar.value = PlayerStats.energy

func _on_ManaArea_mouse_entered():
	$ManaUI/ManaLabel.visible = true


func _on_ManaArea_mouse_exited():
	$ManaUI/ManaLabel.visible = false


func _on_HealthArea_mouse_entered():
	$HealthUI/HealthLabel.visible = true


func _on_HealthArea_mouse_exited():
	$HealthUI/HealthLabel.visible = false


func _on_EnergyArea_mouse_entered():
	$EnergyUI/EnergyLabel.visible = true
	$EnergyUI/EnergyLabel.text = "ENERGY - " + str(PlayerStats.energy) + " / " + str(PlayerStats.energy_maximum)


func _on_EnergyArea_mouse_exited():
	$EnergyUI/EnergyLabel.visible = false
