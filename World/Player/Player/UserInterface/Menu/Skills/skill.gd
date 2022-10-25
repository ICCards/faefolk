extends HBoxContainer



func _ready():
	$Title.text = name
	$Icon.texture = load("res://Assets/Images/Inventory UI/skills/"+ name +".png")
	set_level()

func set_level():
	var skill_level = CollectionsData.skills[name]
	$Level.text = str(skill_level)
	for i in range(skill_level):
		if i == 4 or i == 9:
			get_node(str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked large.png")
		else:
			get_node(str(i+1)).texture = preload("res://Assets/Images/Inventory UI/skills/unlocked small.png")
