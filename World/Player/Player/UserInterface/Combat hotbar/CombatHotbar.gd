extends Control

var hovered_item

func _ready():
	PlayerData.connect("energy_changed",Callable(self,"set_energy_bar"))
	PlayerData.connect("health_changed",Callable(self,"set_health_bar"))
	PlayerData.connect("mana_changed",Callable(self,"set_mana_bar"))
	Stats.connect("tool_health_change_combat_hotbar",Callable(self,"update_tool_health"))


func _on_SwitchHotbarBtn_pressed():
	get_parent().switch_hotbar()

func update_tool_health():
	var slots = $ItemSlots.get_children()
	var item_name = PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0]
	if PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2] == 0 and item_name != "stone watering can" and item_name != "bronze watering can" and item_name != "gold watering can":
		slots[PlayerData.active_item_slot_combat_hotbar].removeFromSlot()
		PlayerData.remove_item(slots[PlayerData.active_item_slot_combat_hotbar])
		await get_tree().create_timer(0.15).timeout
		$SoundEffects.stream = Sounds.tool_break
		$SoundEffects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
		$SoundEffects.play()
	else:
		slots[PlayerData.active_item_slot_combat_hotbar].initialize_item(PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][0], PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][1], PlayerData.player_data["combat_hotbar"][str(PlayerData.active_item_slot_combat_hotbar)][2])


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

