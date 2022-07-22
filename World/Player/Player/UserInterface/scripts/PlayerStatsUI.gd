extends Node2D



func _ready():
	PlayerStats.connect("energy_changed", self, "set_energy_bar")
	PlayerStats.connect("health_changed", self, "set_health_bar")
	set_energy_bar()
	set_health_bar()
	
func set_energy_bar():
	$EnergyUI/EnergyPgBar.max_value = PlayerStats.energy_maximum
	$EnergyUI/EnergyPgBar.value = PlayerStats.energy
	
func set_health_bar():
	$HealthUI/HealthPgBar.max_value = PlayerStats.health_maximum
	$HealthUI/HealthPgBar.value = PlayerStats.health
	

func _on_ManaArea_mouse_entered():
	$ManaUI/ManaLabel.visible = true


func _on_ManaArea_mouse_exited():
	$ManaUI/ManaLabel.visible = false


func _on_HealthArea_mouse_entered():
	$HealthUI/HealthLabel.visible = true
	$HealthUI/HealthLabel.text = "HEALTH - " + str(PlayerStats.health) + " / " + str(PlayerStats.health_maximum)


func _on_HealthArea_mouse_exited():
	$HealthUI/HealthLabel.visible = false


func _on_EnergyArea_mouse_entered():
	$EnergyUI/EnergyLabel.visible = true
	$EnergyUI/EnergyLabel.text = "ENERGY - " + str(PlayerStats.energy) + " / " + str(PlayerStats.energy_maximum)


func _on_EnergyArea_mouse_exited():
	$EnergyUI/EnergyLabel.visible = false
