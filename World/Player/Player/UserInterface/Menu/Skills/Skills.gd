extends Control

func initialize():
	$CompositeSprites.set_player_animation(Server.player_node.character, "idle_down")
	$CompositeSprites/AnimationPlayer.play("loop")
	show()
	for skill in $ScrollContainer/SkillColumn.get_children():
		skill.initialize()
