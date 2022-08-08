extends Node2D

onready var InsidePlayerHome = preload("res://World/InsidePlayerHouse/InsidePlayerHome.tscn")


func set_player_inside_house():
	$MovementCollisionBox/CollisionPolygon2D.set_deferred("disabled", true)
	$Doorway/CollisionShape2D.set_deferred("disabled", true)

func set_player_outside_house():
	$MovementCollisionBox/CollisionPolygon2D.set_deferred("disabled", false)
	$Doorway/CollisionShape2D.set_deferred("disabled", false)
	
	

func _on_Doorway_area_entered(_area):
#	Server.player_node = Server.world.get_node("Players/"+Server.player_id)
#	Server.world = null
#	Server.isLoaded = false
#	SceneChanger.goto_scene("res://World/InsidePlayerHouse/InsidePlayerHome.tscn")
	get_node("/root/World").set_world_invisible()
	var insidePlayerHome = InsidePlayerHome.instance()
	insidePlayerHome.name = "InsidePlayerHome"
	insidePlayerHome.position = get_node("/root/World/Players/" + Server.player_id).position + Vector2(-200, -450)
	get_node("/root/World").call_deferred("add_child", insidePlayerHome)

onready var tween = $Tween
func set_house_transparent():
	tween.interpolate_property($HouseSprite, "modulate",
		$HouseSprite.get_modulate(), Color(1, 1, 1, 0.5), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func set_house_visible():
	tween.interpolate_property($HouseSprite, "modulate",
		$HouseSprite.get_modulate(), Color(1, 1, 1, 1), 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	

func _on_BehindHouseArea_area_entered(_area):
	set_house_transparent()


func _on_BehindHouseArea_area_exited(_area):
	set_house_visible()
