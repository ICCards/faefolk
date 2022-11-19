extends ColorRect


var rng = RandomNumberGenerator.new()

func _ready():
	play_lightning_effect()

func play_lightning_effect():
	rng.randomize()
	var randomDelay = rng.randi_range(20, 50)
	if Server.player_node and has_node("/root/World"):
		yield(get_tree().create_timer(randomDelay), "timeout")
		if Server.player_node.position.distance_to(get_node("/root/World/RoamingStorm").position) <= 2000:
			$AnimationPlayer.play("lightning day")
			$ThunderSoundEffects.volume_db = Sounds.return_adjusted_sound_db("ambient", -12)
			$ThunderSoundEffects.play()
		play_lightning_effect()
