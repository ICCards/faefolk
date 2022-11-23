extends ColorRect


var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	$LightningTimer.start(rand_range(30,60))

func play_lightning_effect():
	if Server.player_node and has_node("/root/World"):
		if Server.player_node.position.distance_to(get_node("/root/World/RoamingStorm").position) <= 2000:
			$AnimationPlayer.play("lightning day")
			$ThunderSoundEffects.volume_db = Sounds.return_adjusted_sound_db("ambient", -12)
			$ThunderSoundEffects.play()


func _on_LightningTimer_timeout():
	play_lightning_effect()
	$LightningTimer.start(rand_range(30,60))
