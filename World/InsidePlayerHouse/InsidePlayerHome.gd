extends Node2D


var is_moving_object


func _on_Doorway_area_entered(_area):
	SceneChanger.change_scene("res://World/Farm/PlayerHomeFarm.tscn", "door")


func _ready(): 
	initialize_house_objects()


onready var DisplaceHouseObject = preload("res://World/InsidePlayerHouse/DisplayHouseObject.tscn")

func initialize_house_objects():
	for i in range(PlayerInventory.player_home.size()):
		var displayHouseObject = DisplaceHouseObject.instance()
		displayHouseObject.init(PlayerInventory.player_home[i][0], PlayerInventory.player_home[i][1])
		add_child(displayHouseObject)
		displayHouseObject.global_position = PlayerInventory.player_home[i][1] * 32 + Vector2(0, 160)

