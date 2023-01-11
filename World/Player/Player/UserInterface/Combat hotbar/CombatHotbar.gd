extends Control

var hovered_item

func _ready():
	PlayerData.connect("energy_changed", self, "set_energy_bar")
	PlayerData.connect("health_changed", self, "set_health_bar")
	PlayerData.connect("mana_changed", self, "set_mana_bar")


func _on_SwitchHotbarBtn_pressed():
	get_parent().switch_hotbar()

	
func initialize():
	show()
	set_energy_bar()
	set_health_bar()
	set_mana_bar()
	$ItemSlots.initialize_slots()

func set_energy_bar():
	$Progresses/Energy/Back.value = PlayerData.player_data["energy"]
	$Progresses/Energy/Front.value = PlayerData.player_data["energy"] - 9

func set_health_bar():
	$Progresses/Health/Back.value = PlayerData.player_data["health"]
	$Progresses/Health/Front.value = PlayerData.player_data["health"] - 7

func set_mana_bar():
	$Progresses/Mana/Back.value = PlayerData.player_data["mana"]
	$Progresses/Mana/Front.value = PlayerData.player_data["mana"] - 7

