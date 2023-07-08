extends Control

@onready var sound_effects: AudioStreamPlayer = $SoundEffects
@onready var button: TextureButton = $TextureButton

var init_text: String = "Welcome to the world of FaeFolk! Survival here is no easy feat; harvest resources, build a base, and explore the underworld to fend off the dangerous mobs..."
var init_text2: String = "....A huge thanks to the Dfinity organization for funding our current progress. Press 'I' to open the game menu and view the rest of the controls. Good luck!"
var respawn_text: String = "You died! Your items will remain for ~90 seconds before they disappear. Find food or potions to restore your energy and health. Sleep to set a respawn point."
var blueprint_text: String = "The blueprint is used to build the foundation and walls of your base. Right-click to open the building menu."
var hammer_text: String = "The hammer has 3 utilities -
 1) Swing to repair  
 2) Right-click to upgrade walls 
 3) Left-click to quick move placeable objects"
var cave_text1: String = "You found the Fae! The caves are filled with valueable resouces that are crucial to your survival. However, they are not easy to obtain. Be sure to prepare..."
var cave_text2: String = "...yourself with weapons and food before you enter. You can not place objects in the caves and if you die, your inventory can not be retrieved."
var wind_fae_text: String = "Would you like to enter the Wind Fae?"
var fire_fae_text: String = "Would you like to enter the Fire Fae?"
var ice_fae_text: String = "Would you like to enter the Ice Fae?"

var locked_fae_text: String = "You have not unlocked this area yet."


var down_arrow_visible: bool = false
var yes_button_enabled: bool = false
var key

func initialize(_key):
	if PlayerData.normal_hotbar_mode:
		get_node("../Hotbar").hide()
		get_node("../Hotbar").item = null
	else:
		get_node("../CombatHotbar").hide()
	get_tree().paused = true
	key = _key
	var text
	match key:
		"init":
			text = init_text
			down_arrow_visible = true
		"init2":
			text = init_text2
			down_arrow_visible = false
		"respawn":
			text = respawn_text
		"blueprint":
			text = blueprint_text
		"hammer":
			text = hammer_text
		"caves":
			text = cave_text1
			down_arrow_visible = true
		"caves2":
			text = cave_text2
			down_arrow_visible = false
		"locked fae":
			text = locked_fae_text
		"wind fae":
			text = wind_fae_text
		"fire fae":
			text = fire_fae_text
		"ice fae":
			text = ice_fae_text
	if key == "wind fae" or key == "fire fae" or key == "ice fae":
		yes_button_enabled = true
	else:
		yes_button_enabled = false
	if down_arrow_visible:
		button.texture_normal = load("res://Assets/Images/User interface/ItemPickUpBox/a3.png")
	else:
		button.texture_normal = load("res://Assets/Images/User interface/ItemPickUpBox/x3.png")
	show()
	button.disabled = true
	button.hide()
	$YesIcon.disabled = true
	$YesIcon.hide()
	$Label.text = ""
	PlayerData.interactive_screen_mode = true
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Dialogue/dialogueCharacterOpen.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
	await get_tree().create_timer(1.0).timeout
	for char in text.length()+1:
		$Label.text = text.left(char)
		play_dialogue_sound_effect()
		await get_tree().create_timer(0.03).timeout
	button.disabled = false
	button.show()
	if yes_button_enabled:
		$YesIcon.show()
		$YesIcon.disabled = false



func _on_texture_button_pressed():
	if key == "init":
		initialize("init2")
		Sounds.play_small_select_sound()
		return
	if key == "caves":
		initialize("caves2")
		Sounds.play_small_select_sound()
		return
	get_tree().paused = false
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Dialogue/dialogueCharacterClose.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
	hide()
	if PlayerData.normal_hotbar_mode:
		get_node("../Hotbar").show()
	else:
		get_node("../CombatHotbar").show()
	PlayerData.interactive_screen_mode = false


func play_dialogue_sound_effect():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Dialogue/dialogueCharacter.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",-4)
	sound_effects.play()


func _on_yes_icon_pressed():
	get_tree().paused = false
	sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Dialogue/dialogueCharacterClose.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	sound_effects.play()
	hide()
	if PlayerData.normal_hotbar_mode:
		get_node("../Hotbar").show()
	else:
		get_node("../CombatHotbar").show()
	PlayerData.interactive_screen_mode = false
	if key == "wind fae":
		SceneChanger.cave_tier = "wind"
		SceneChanger.cave_level = 1
		SceneChanger.goto_scene("res://World/Caves/random_cave.tscn")



