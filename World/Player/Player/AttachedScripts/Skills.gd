extends Control


func initialize():
	$CompositeSprites.set_player_animation(Server.player_node.character, "idle_down")
	$CompositeSprites/AnimationPlayer.play("loop")
	show()
	for skill in CollectionsData.skills.keys():
		var skill_level = CollectionsData.skills[skill]
		get_node("SkillColumn/" + skill + "/Level").text = str(skill_level)
		for i in range(skill_level):
			if i == 4 or i == 9:
				get_node("SkillColumn/" + skill + "/" + str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked large.png")
			else:
				get_node("SkillColumn/" + skill + "/" + str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked small.png")
