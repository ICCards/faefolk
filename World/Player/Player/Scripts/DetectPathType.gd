extends Node2D


func _on_DetectWoodPath_area_entered(area):
	if Sounds.current_footsteps_sound != Sounds.wood_footsteps:
		Sounds.current_footsteps_sound = Sounds.wood_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()

func _on_DetectWoodPath_area_exited(area):
	if $DetectWoodPath.get_overlapping_areas().size() <= 0 and $DetectStonePath.get_overlapping_areas().size() <= 0:
		Sounds.current_footsteps_sound = Sounds.dirt_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()

func _on_DetectStonePath_area_entered(area):
	if Sounds.current_footsteps_sound != Sounds.stone_footsteps:
		Sounds.current_footsteps_sound = Sounds.stone_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", 0)
		$FootstepsSound.play()

func _on_DetectStonePath_area_exited(area):
	if $DetectStonePath.get_overlapping_areas().size() <= 0 and $DetectWoodPath.get_overlapping_areas().size() <= 0:
		Sounds.current_footsteps_sound = Sounds.dirt_footsteps
		$FootstepsSound.stream = Sounds.current_footsteps_sound
		$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -10)
		$FootstepsSound.play()



