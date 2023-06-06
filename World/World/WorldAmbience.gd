extends CanvasModulate

const LENGTH_OF_TRANSITION = 60.0

const CURSE_COLOR = Color("cd0000")

func _ready():
	PlayerData.connect("set_day",Callable(self,"play_set_day"))
	PlayerData.connect("set_night",Callable(self,"play_set_night"))
	if PlayerData.player_data:
		if PlayerData.player_data["time_hours"] >= 22 or PlayerData.player_data["time_hours"] < 6: # night time
			set_deferred("color", Color("323237"))

func play_set_day():
	if Server.world.name == "World":
		call_deferred("set_day")

func play_set_night():
	if Server.world.name == "World":
		call_deferred("set_night")

func set_day():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color("ffffff"), LENGTH_OF_TRANSITION)


func set_night():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color("323237"), LENGTH_OF_TRANSITION)


func set_curse_effect():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", CURSE_COLOR, 3.0)

