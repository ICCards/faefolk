extends TextureButton


func _ready():
	set_btn_texture()
	
func set_btn_texture():
	var spell = name.split(" ")
	var experience = PlayerData.player_data["skill_experience"][spell[0]]
	var level
	if experience == 0:
		level = 0
	elif experience < 100:
		level = 1
	elif experience < 500:
		level = 2
	elif experience < 1000:
		level = 3
	else: 
		level = 4
	if level >= int(spell[1]):
		self.texture_normal = load("res://Assets/Images/Spell icons/"+spell[0]+"/"+spell[1]+".png")
	else:
		self.texture_normal = load("res://Assets/Images/Spell icons/"+spell[0]+"/locked.png")


func _on_SpellIconBtn_pressed():
	var spell = name.split(" ")
	PlayerData.player_data["combat_hotbar"][str(int(spell[1])-1)] = spell[0]
	get_node("../../../").initialize()


func _on_SpellIconBtn_mouse_entered():
	pass # Replace with function body.


func _on_SpellIconBtn_mouse_exited():
	pass # Replace with function body.
