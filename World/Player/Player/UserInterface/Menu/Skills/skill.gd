extends Control

func initialize():
	$Title.text = name[0].to_upper() + name.substr(1,-1)
	$HBoxContainer/Icon.texture = load("res://Assets/Images/Inventory UI/skills/"+ name +".png")
	set_level()

func set_level():
	var skill_level = CollectionsData.skills[name]
	$HBoxContainer/Level.text = str(skill_level)
	for i in range(skill_level):
		if i == 4 or i == 9:
			$HBoxContainer.get_node(str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked large.png")
		else:
			$HBoxContainer.get_node(str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked small.png")
