extends ColorRect


var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	yield(get_tree(), "idle_frame")
	if Server.world.name == "World":
		show()
	else:
		hide()
	PlayerData.connect("set_day", self, "play_set_day")
	PlayerData.connect("set_night", self, "play_set_night")
	$LightningTimer.start(rand_range(30,60))
	if PlayerData.player_data["time_hours"] >= 18 or PlayerData.player_data["time_hours"] < 6:
		color = Color("ec00070e")
	

func play_set_day():
	if Server.world.name == "World":
		$AnimationPlayer.play_backwards("set night")

func play_set_night():
	if Server.world.name == "World":
		$AnimationPlayer.play("set night")

func play_lightning_effect():
	if Server.player_node and has_node("/root/World"):
		if Server.player_node.position.distance_to(get_node("/root/World/RoamingStorm").position) <= 2000:
			$AnimationPlayer.play("lightning day")
			$ThunderSoundEffects.volume_db = Sounds.return_adjusted_sound_db("ambient", -12)
			$ThunderSoundEffects.play()


func _on_LightningTimer_timeout():
	play_lightning_effect()
	$LightningTimer.start(rand_range(30,60))
