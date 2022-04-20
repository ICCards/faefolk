extends YSort


var is_moving_object

func _ready():
	initialize_house_objects()


func _on_Doorway_area_entered(area):
	SceneChanger.change_scene("res://World/World.tscn")


onready var DisplaceHouseObject = preload("res://InsidePlayerHouse/DisplayHouseObject.tscn")
onready var world = get_tree().current_scene

func initialize_house_objects():
	for i in range(PlayerInventory.player_home.size()):
		var displayHouseObject = DisplaceHouseObject.instance()
		displayHouseObject.init(PlayerInventory.player_home[i][0], PlayerInventory.player_home[i][1])
		add_child(displayHouseObject)
		displayHouseObject.global_position = PlayerInventory.player_home[i][1] * 32 + Vector2(0, 160)

