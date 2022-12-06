extends Control

var skill = "sword"

func _ready():
	initialize()

func initialize():
	set_bg()
	
func set_bg():
	$Background.texture = load("res://Assets/Images/Inventory UI/skill menus/"+skill+".png")
	$Title.text = skill[0].to_upper() + skill.substr(1,-1)
	set_skills()
	match skill:
		"sword":
			$Title.rect_position.x = -227
			$BowBtn.rect_position.x = -125
			$WindBtn.rect_position.x = -65
			$FireBtn.rect_position.x = -5
			$EarthBtn.rect_position.x = 55
			$IceBtn.rect_position.x = 115
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"bow":
			$Title.rect_position.x = -167
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -65
			$FireBtn.rect_position.x = -5
			$EarthBtn.rect_position.x = 55
			$IceBtn.rect_position.x = 115
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"wind":
			$Title.rect_position.x = -107
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -5
			$EarthBtn.rect_position.x = 55
			$IceBtn.rect_position.x = 115
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"fire":
			$Title.rect_position.x = -47
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -110
			$EarthBtn.rect_position.x = 55
			$IceBtn.rect_position.x = 115
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"earth":
			$Title.rect_position.x = 13
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -110
			$EarthBtn.rect_position.x = -50
			$IceBtn.rect_position.x = 115
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"ice":
			$Title.rect_position.x = 73
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -110
			$EarthBtn.rect_position.x = -50
			$IceBtn.rect_position.x = 10
			$ElectricBtn.rect_position.x = 175
			$DarkMagicBtn.rect_position.x = 235
		"electric":
			$Title.rect_position.x = 133
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -110
			$EarthBtn.rect_position.x = -50
			$IceBtn.rect_position.x = 10
			$ElectricBtn.rect_position.x = 70
			$DarkMagicBtn.rect_position.x = 235
		"dark":
			$Title.rect_position.x = 193
			$BowBtn.rect_position.x = -230
			$WindBtn.rect_position.x = -170
			$FireBtn.rect_position.x = -110
			$EarthBtn.rect_position.x = -50
			$IceBtn.rect_position.x = 10
			$ElectricBtn.rect_position.x = 70
			$DarkMagicBtn.rect_position.x = 130
			
func set_skills():
	var level = CollectionsData.skills[skill]
	if level == 0:
		$Icon1.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon2.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon3.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon4.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$AttackTitles/Attack1.text = "?????"
		$AttackTitles/Attack2.text = "?????"
		$AttackTitles/Attack3.text = "?????"
		$AttackTitles/Attack4.text = "?????"
	elif level == 1:
		print(CollectionsData.skill_descriptions[skill])
		$Icon1.texture = load("res://Assets/Images/Spell icons/"+skill+"/1.png")
		$Icon2.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon3.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon4.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$AttackTitles/Attack1.text = CollectionsData.skill_descriptions[skill][1]["n"]
		$AttackTitles/Attack2.text = "?????"
		$AttackTitles/Attack3.text = "?????"
		$AttackTitles/Attack4.text = "?????"
	elif level == 2:
		$Icon1.texture = load("res://Assets/Images/Spell icons/"+skill+"/1.png")
		$Icon2.texture = load("res://Assets/Images/Spell icons/"+skill+"/2.png")
		$Icon3.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$Icon4.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$AttackTitles/Attack1.text = CollectionsData.skill_descriptions[skill][1]["n"]
		$AttackTitles/Attack2.text = CollectionsData.skill_descriptions[skill][2]["n"]
		$AttackTitles/Attack3.text = "?????"
		$AttackTitles/Attack4.text = "?????"
	elif level == 3:
		$Icon1.texture = load("res://Assets/Images/Spell icons/"+skill+"/1.png")
		$Icon2.texture = load("res://Assets/Images/Spell icons/"+skill+"/2.png")
		$Icon3.texture = load("res://Assets/Images/Spell icons/"+skill+"/3.png")
		$Icon4.texture = load("res://Assets/Images/Spell icons/"+skill+"/locked.png")
		$AttackTitles/Attack1.text = CollectionsData.skill_descriptions[skill][1]["n"]
		$AttackTitles/Attack2.text = CollectionsData.skill_descriptions[skill][2]["n"]
		$AttackTitles/Attack3.text = CollectionsData.skill_descriptions[skill][3]["n"]
		$AttackTitles/Attack4.text = "?????"
	elif level == 4:
		$Icon1.texture = load("res://Assets/Images/Spell icons/"+skill+"/1.png")
		$Icon2.texture = load("res://Assets/Images/Spell icons/"+skill+"/2.png")
		$Icon3.texture = load("res://Assets/Images/Spell icons/"+skill+"/3.png")
		$Icon4.texture = load("res://Assets/Images/Spell icons/"+skill+"/4.png")
		$AttackTitles/Attack1.text = CollectionsData.skill_descriptions[skill][1]["n"]
		$AttackTitles/Attack2.text = CollectionsData.skill_descriptions[skill][2]["n"]
		$AttackTitles/Attack3.text = CollectionsData.skill_descriptions[skill][3]["n"]
		$AttackTitles/Attack4.text = CollectionsData.skill_descriptions[skill][4]["n"]
	
#	match skill:
#		"sword":
#
#		"bow":
#
#		"wind":
#
#		"fire":
#
#		"earth":
#
#		"ice":
#
#		"electric":
#
#		"dark":

			

func _on_BowBtn_pressed():
	skill = "bow"
	set_bg()

func _on_WindBtn_pressed():
	skill = "wind"
	set_bg()

func _on_FireBtn_pressed():
	skill = "fire"
	set_bg()

func _on_EarthBtn_pressed():
	skill = "earth"
	set_bg()

func _on_IceBtn_pressed():
	skill = "ice"
	set_bg()

func _on_DarkMagicBtn_pressed():
	skill = "dark"
	set_bg()

func _on_SwordBtn_pressed():
	skill = "sword"
	set_bg()

func _on_ElectricBtn_pressed():
	skill = "electric"
	set_bg()
