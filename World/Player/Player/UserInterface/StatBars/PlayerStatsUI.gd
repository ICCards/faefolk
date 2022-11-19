extends Control

func _ready():
	PlayerStats.connect("energy_changed", self, "set_energy_bar")
	PlayerStats.connect("health_changed", self, "set_health_bar")
	PlayerStats.connect("mana_changed", self, "set_mana_bar")
	set_energy_bar()
	set_health_bar()
	
func set_mana_bar():
	$ManaPgBar.max_value = PlayerStats.mana_maximum
	$ManaPgBar.value = PlayerStats.mana
	
func set_energy_bar():
	$EnergyPgBar.max_value = PlayerStats.energy_maximum
	$EnergyPgBar.value = PlayerStats.energy
	
func set_health_bar():
	$HealthPgBar.max_value = PlayerStats.health_maximum
	$HealthPgBar.value = PlayerStats.health
	

func _on_ManaArea_mouse_entered():
	$ManaLabel.visible = true


func _on_ManaArea_mouse_exited():
	$ManaLabel.visible = false


func _on_HealthArea_mouse_entered():
	$HealthLabel.visible = true
	$HealthLabel.text = "HEALTH - " + str(PlayerStats.health) + " / " + str(PlayerStats.health_maximum)


func _on_HealthArea_mouse_exited():
	$HealthLabel.visible = false


func _on_EnergyArea_mouse_entered():
	$EnergyLabel.visible = true
	$EnergyLabel.text = "ENERGY - " + str(PlayerStats.energy) + " / " + str(PlayerStats.energy_maximum)


func _on_EnergyArea_mouse_exited():
	$EnergyUI/EnergyLabel.visible = false
