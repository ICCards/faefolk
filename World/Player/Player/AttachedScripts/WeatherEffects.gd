extends ColorRect


var rng = RandomNumberGenerator.new()

func _ready():
	play_lightning_effect()

func play_lightning_effect():
	rng.randomize()
	var randomDelay = rng.randi_range(20, 50)
	if has_node("/root/World/Players/" + Server.player_id):
		var player = get_node("/root/World/Players/" + Server.player_id + "/" + Server.player_id)
		yield(get_tree().create_timer(randomDelay), "timeout")
		if player.position.distance_to(get_node("/root/World/RoamingStorm").position) <= 2000:
			$AnimationPlayer.play("lightning day")
			$ThunderSoundEffects.volume_db = Sounds.return_adjusted_sound_db("ambient", -12)
			$ThunderSoundEffects.play()
		play_lightning_effect()
