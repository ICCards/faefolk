extends Node2D



func _ready():
	PlayerStats.connect("energy_changed", self, "set_stat_bars")
	set_stat_bars()
	
func set_stat_bars():
	$EnergyRect.scale.y = (PlayerStats.energy / PlayerStats.energy_maximum ) * 3.125
