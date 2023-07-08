extends Control

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

var selected_spell: int = 1
var selected_staff = ""

var COOL_DOWN_PERIOD_1: float = 0.5
var COOL_DOWN_PERIOD_2: int = 2
var COOL_DOWN_PERIOD_3: int = 5
var COOL_DOWN_PERIOD_4: int = 10


func _ready():
	PlayerDataHelpers.connect("new_skill_unlocked",Callable(self,"play_level_up_sound"))

func play_level_up_sound():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Player/skill unlocked.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	Server.player_node.composite_sprites.play_skill_unlocked()
	set_bgs()

func initialize(item_name):
	show()
	selected_spell = 1
	match item_name:
		"wind staff":
			selected_staff = "wind"
		"fire staff":
			selected_staff = "fire"
		"earth staff":
			selected_staff = "earth"
		"ice staff":
			selected_staff = "ice"
		"dark magic staff":
			selected_staff = "dark"
		"electric staff":
			selected_staff = "electric"
		"bow":
			selected_staff = "bow"
		_:
			selected_staff = "sword"
	set_selected_spell()
	set_bgs()

func set_bgs():
	if selected_staff != "":
		var experience = PlayerData.player_data["skill_experience"][selected_staff]
		var level
		if experience == 0:
			level = 0
			$Bg/btn1.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn2.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn3.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn4.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn1.disabled = true
			$Bg/btn2.disabled = true
			$Bg/btn3.disabled = true
			$Bg/btn4.disabled = true
		elif experience < 100:
			level = 1
			$Bg/btn1.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/1.png")
			$Bg/btn2.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn3.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn4.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn1.disabled = false
			$Bg/btn2.disabled = true
			$Bg/btn3.disabled = true
			$Bg/btn4.disabled = true
		elif experience < 500:
			level = 2
			$Bg/btn1.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/1.png")
			$Bg/btn2.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/2.png")
			$Bg/btn3.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn4.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn1.disabled = false
			$Bg/btn2.disabled = false
			$Bg/btn3.disabled = true
			$Bg/btn4.disabled = true
		elif experience < 1000:
			level = 3
			$Bg/btn1.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/1.png")
			$Bg/btn2.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/2.png")
			$Bg/btn3.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/3.png")
			$Bg/btn4.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/locked.png")
			$Bg/btn1.disabled = false
			$Bg/btn2.disabled = false
			$Bg/btn3.disabled = false
			$Bg/btn4.disabled = true
		else: 
			level = 4
			$Bg/btn1.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/1.png")
			$Bg/btn2.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/2.png")
			$Bg/btn3.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/3.png")
			$Bg/btn4.texture_normal = load("res://Assets/Images/Spell icons/" + selected_staff + "/4.png")
			$Bg/btn1.disabled = false
			$Bg/btn2.disabled = false
			$Bg/btn3.disabled = false
			$Bg/btn4.disabled = false


func set_selected_spell():
	match selected_spell:
		1:
			$SelectedBg.position.x = 0
		2:
			$SelectedBg.position.x = 60
		3:
			$SelectedBg.position.x = 120
		4:
			$SelectedBg.position.x = 180


func start_spell_cooldown(spell_index):
	get_node("Cooldown"+str(spell_index)).size = Vector2(48,48)
	var tween = get_tree().create_tween()
	match spell_index:
		1:
			tween.tween_property(get_node("Cooldown"+str(spell_index)), "size", Vector2(48,0), COOL_DOWN_PERIOD_1)
		2:
			tween.tween_property(get_node("Cooldown"+str(spell_index)), "size", Vector2(48,0), COOL_DOWN_PERIOD_2)
		3:
			tween.tween_property(get_node("Cooldown"+str(spell_index)), "size", Vector2(48,0), COOL_DOWN_PERIOD_3)
		4:
			tween.tween_property(get_node("Cooldown"+str(spell_index)), "size", Vector2(48,0), COOL_DOWN_PERIOD_4)

func validate_spell_cooldown(spell_index):
	return get_node("Cooldown"+str(spell_index)).size.y == 0 and not get_node("Bg/btn"+str(spell_index)).disabled

func _on_btn1_pressed():
	Sounds.play_small_select_sound()
	selected_spell = 1
	set_selected_spell()

func _on_btn2_pressed():
	Sounds.play_small_select_sound()
	selected_spell = 2
	set_selected_spell()

func _on_btn3_pressed():
	Sounds.play_small_select_sound()
	selected_spell = 3
	set_selected_spell()

func _on_btn4_pressed():
	Sounds.play_small_select_sound()
	selected_spell = 4
	set_selected_spell()
