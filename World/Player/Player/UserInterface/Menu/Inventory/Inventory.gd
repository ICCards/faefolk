extends Control

onready var sound_effects: AudioStreamPlayer = $SoundEffects

var hovered_item = null

func _ready():
	PlayerData.connect("set_day", self, "set_day_bg")
	PlayerData.connect("set_night", self, "set_night_bg")
	$CompositeSprites/AnimationPlayer.play("loop")

func initialize():
	show()
	get_node("../../Background").texture = load("res://Assets/Images/User interface/inventory/inventory/inventory-tab.png")
	$InventorySlots.initialize_slots()
	$HotbarInventorySlots.initialize_slots()
	PlayerData.InventorySlots = $InventorySlots
	hovered_item = null
	$EnergyManaHealth.initialize()
	$BaseStats.initialize()
	if PlayerData.player_data["time_hours"] >= 22 or PlayerData.player_data["time_hours"] < 6:
		set_night_bg()
	else:
		set_day_bg()

func set_day_bg():
	$DayNightBg.texture = load("res://Assets/Images/Inventory UI/day.png")

func set_night_bg():
	$DayNightBg.texture = load("res://Assets/Images/Inventory UI/night.png")

func _physics_process(delta):
	if not visible:
		return
	if hovered_item and not find_parent("UserInterface").holding_item:
		get_node("../../ItemDescription").show()
		get_node("../../ItemDescription").item_category = JsonData.item_data[hovered_item]["ItemCategory"]
		get_node("../../ItemDescription").item_name = hovered_item
		get_node("../../ItemDescription").initialize()
	else:
		get_node("../../ItemDescription").hide()




