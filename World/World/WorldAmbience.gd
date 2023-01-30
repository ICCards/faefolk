extends CanvasModulate

const LENGTH_OF_TRANSITION = 60.0

func _ready():
#	PlayerData.connect("set_day", self, "play_set_day")
#	PlayerData.connect("set_night", self, "play_set_night")
#	if PlayerData.player_data:
#		if PlayerData.player_data["time_hours"] >= 22 or PlayerData.player_data["time_hours"] < 6: # night time
			set_deferred("color", Color("28282d"))

func play_set_day():
	if Server.world.name == "World":
		call_deferred("set_day")

func play_set_night():
	if Server.world.name == "World":
		call_deferred("set_night")

func set_day():
	$Tween.interpolate_property(self, "color",
		Color("28282d"), Color("ffffff"), LENGTH_OF_TRANSITION,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func set_night():
	$Tween.interpolate_property(self, "color",
		Color("ffffff"), Color("28282d"), LENGTH_OF_TRANSITION,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
