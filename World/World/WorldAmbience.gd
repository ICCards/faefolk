extends CanvasModulate


func _ready():
	PlayerData.connect("set_day", self, "play_set_day")
	PlayerData.connect("set_night", self, "play_set_night")
	if PlayerData.player_data:
		if PlayerData.player_data["time_hours"] >= 22 or PlayerData.player_data["time_hours"] < 6:
			color = Color("28282d")

func play_set_day():
	if Server.world.name == "World":
		$Tween.interpolate_property(self, "color",
			Color("28282d"), Color("ffffff"), 120.0,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func play_set_night():
	if Server.world.name == "World":
		$Tween.interpolate_property(self, "color",
			Color("ffffff"), Color("28282d"), 120.0,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
