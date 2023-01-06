extends Control

var hovered_item

func _ready():
	PlayerData.connect("energy_changed", self, "set_energy_bar")
	PlayerData.connect("health_changed", self, "set_health_bar")
	PlayerData.connect("mana_changed", self, "set_mana_bar")


func _on_SwitchHotbarBtn_pressed():
	get_parent().switch_hotbar()


func _on_SetBtn_pressed():
	if not $CombatHotbarMenu.visible:
		PlayerData.interactive_screen_mode = true
		$CombatHotbarMenu.initialize()
	else:
		PlayerData.interactive_screen_mode = false
		$CombatHotbarMenu.hide()


func set_selected_slot():
	$SelectedSlot.rect_position.x = 399 + PlayerData.active_item_slot_combat_hotbar*60
	if PlayerData.active_item_slot_combat_hotbar >= 4:
		$SelectedSlot.rect_position.x += 12

func initialize():
	show()
	set_energy_bar()
	set_health_bar()
	set_mana_bar()
	set_selected_slot()
	var slots = $SpellSlots.get_children()
	for i in range(slots.size()):
		if PlayerData.player_data["combat_hotbar"].has(str(i)):
			set_current_button(i,PlayerData.player_data["combat_hotbar"][str(i)])
		else:
			get_node("SpellSlots/"+str(str(i+1))).modulate.a = 0.0
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


func set_current_button(slot_index,spell_name):
	var experience = PlayerData.player_data["skill_experience"][spell_name]
	var level
	if experience == 0:
		level = 0
	elif experience < 100:
		level = 1
	elif experience < 500:
		level = 2
	elif experience < 1000:
		level = 3
	else: 
		level = 4
	get_node("SpellSlots/"+str(slot_index+1)).modulate.a = 1.0
	if level >= int(slot_index+1):
		get_node("SpellSlots/"+str(slot_index+1)).texture_normal = load("res://Assets/Images/Spell icons/"+spell_name+"/"+str(slot_index+1)+".png")
	else:
		get_node("SpellSlots/"+str(slot_index+1)).texture_normal = load("res://Assets/Images/Spell icons/"+spell_name+"/locked.png")
	


func _on_1_pressed():
	PlayerData.active_item_slot_combat_hotbar = 0
	set_selected_slot()

func _on_2_pressed():
	PlayerData.active_item_slot_combat_hotbar = 1
	set_selected_slot()

func _on_3_pressed():
	PlayerData.active_item_slot_combat_hotbar = 2
	set_selected_slot()

func _on_4_pressed():
	PlayerData.active_item_slot_combat_hotbar = 3
	set_selected_slot()
