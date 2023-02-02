extends Node

signal volume_change
signal footsteps_sound_change

var background_songs = [load("res://Assets/Sound/music/bg music.mp3"),load("res://Assets/Sound/music/edutainment.mp3"),load("res://Assets/Sound/music/make it easy.mp3")]


func play_pick_up_item_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/slots/pickUpItem.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	Server.player_node.sound_effects.play()
	
func play_put_down_item_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/slots/putDownItem.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	Server.player_node.sound_effects.play()

func play_small_select_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/smallSelect.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	Server.player_node.sound_effects.play()

func play_big_select_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/bigSelect.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	Server.player_node.sound_effects.play()

func play_deselect_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Menu/bigDeSelect.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	Server.player_node.sound_effects.play()

func play_error_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/ES_Error Tone Chime 6 - SFX Producer.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",-20)
	Server.player_node.sound_effects.play()

func play_menu_select_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/Buttons/select.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	Server.player_node.sound_effects.play()

func play_hotbar_slot_selected_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/slot.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	Server.player_node.sound_effects.play()

func play_harvest_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/Farming/harvest.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	Server.player_node.sound_effects.play()
	
func play_auto_add_chest_sound():
	Server.player_node.sound_effects.stream = load("res://Assets/Sound/Sound effects/UI/slots/auto add chest slot.mp3")
	Server.player_node.sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound",0)
	Server.player_node.sound_effects.play()

func set_music_volume(val):
	PlayerData.player_data["settings"]["volume"]["music"] = val
	emit_signal("volume_change")

func set_sound_volume(val):
	PlayerData.player_data["settings"]["volume"]["sound"] = val
	emit_signal("volume_change")

func set_ambient_volume(val):
	PlayerData.player_data["settings"]["volume"]["ambient"] = val
	emit_signal("volume_change")

func set_footstep_volume(val):
	PlayerData.player_data["settings"]["volume"]["footstep"] = val
	emit_signal("volume_change")
	
func return_adjusted_sound_db(category, init_sound):
	if category == "music":
		var progress = PlayerData.player_data["settings"]["volume"]["music"] / 100
		if progress == 0.5:
			return init_sound
		elif progress < 0.5:
			var dis_to_mute =  -(80 + init_sound)
			return (init_sound + ((1 - (progress * 2)) * dis_to_mute))
		elif progress > 0.5:
			return init_sound + ((progress - 0.5) / 5) * 150
	elif category == "sound":
		var progress =  PlayerData.player_data["settings"]["volume"]["sound"] / 100
		if progress == 0.5:
			return init_sound
		elif progress < 0.5:
			var dis_to_mute =  -(80 + init_sound)
			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
		elif progress > 0.5:
			return init_sound + ((progress - 0.5) / 5) * 150
	elif category == "ambient":
		var progress = PlayerData.player_data["settings"]["volume"]["ambient"] / 100
		if progress == 0.5:
			return init_sound
		elif progress < 0.5:
			var dis_to_mute =  -(80 + init_sound)
			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
		elif progress > 0.5:
			return init_sound + ((progress - 0.5) / 5) * 150
	elif category == "footstep":
		var progress = PlayerData.player_data["settings"]["volume"]["footstep"] / 100
		if progress == 0.5:
			return init_sound
		elif progress < 0.5:
			var dis_to_mute =  -(60 + init_sound)
			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
		elif progress > 0.5:
			return init_sound + ((progress - 0.5) / 5) * 150


### Handles switching footsteps sound

var current_footsteps_sound


### Sound effects ##
var wood_footsteps = load("res://Assets/Sound/Sound effects/Footsteps/wood footsteps.mp3")
var dirt_footsteps = load("res://Assets/Sound/Sound effects/Footsteps/dirt footsteps.mp3")
var stone_footsteps = load("res://Assets/Sound/Sound effects/Footsteps/stone footsteps.mp3")
var swimming = load("res://Assets/Sound/Sound effects/Footsteps/swimming.mp3")

#var button_hover = load("res://Assets/Sound/Sound effects/UI/button hover.mp3")
var button_select = load("res://Assets/Sound/Sound effects/UI/Menu/bigSelect.mp3")

var pick_up_item = load("res://Assets/Sound/Sound effects/UI/pick up item.mp3")

var place_object = load("res://Assets/Sound/Sound effects/Building/place object.mp3")

var pick_up_house_object = load("res://Assets/Sound/Sound effects/UI/pick up house object.mp3")
var put_down_house_object = load("res://Assets/Sound/Sound effects/UI/put down house object.mp3")

#var door_open = load("res://Assets/Sound/Sound effects/Door/door open.mp3")
#var door_close = load("res://Assets/Sound/Sound effects/Door/door close.mp3")

var chest_open = load("res://Assets/Sound/Sound effects/chest/open.mp3")

var ore_hit = [
	load("res://Assets/Sound/Sound effects/Ore/Ore hit 1.mp3"),
	load("res://Assets/Sound/Sound effects/Ore/Ore hit 2.mp3"),
	load("res://Assets/Sound/Sound effects/Ore/Ore hit 3.mp3"),
	]

var ore_break = [
	load("res://Assets/Sound/Sound effects/Ore/Ore break 1.mp3"),
	load("res://Assets/Sound/Sound effects/Ore/Ore break 2.mp3"),
	load("res://Assets/Sound/Sound effects/Ore/Ore break 3.mp3")
	]

var tree_hit = [
	load("res://Assets/Sound/Sound effects/Tree/Tree hit 1.mp3"),
	load("res://Assets/Sound/Sound effects/Tree/Tree hit 2.mp3"),
	load("res://Assets/Sound/Sound effects/Tree/Tree hit 3.mp3")
]

var sword_whoosh = [
	load("res://Assets/Sound/Sound effects/Sword/sword whoosh.mp3"),
	load("res://Assets/Sound/Sound effects/Sword/sword whoosh 2.mp3"),
]

var tree_break = load("res://Assets/Sound/Sound effects/Tree/Falling tree.mp3")
var stump_break = load("res://Assets/Sound/Sound effects/Tree/Stump break.mp3")
var tool_break = load("res://Assets/Sound/Sound effects/objects/tool break.mp3")

var bear_grown = [
	load("res://Assets/Sound/Sound effects/Animals/Bear/Groan/groan 1.mp3"),
	load("res://Assets/Sound/Sound effects/Animals/Bear/Groan/groan 2.mp3"),
	load("res://Assets/Sound/Sound effects/Animals/Bear/Groan/groan 3.mp3")
]


### Ambient ###

var fire_start = load("res://Assets/Sound/Sound effects/Fire/start.mp3")
var fire_crackle = load("res://Assets/Sound/Sound effects/Fire/crackle.mp3")

### Music ###
var title_music = load("res://Assets/Sound/music/wobble dance.mp3")
#var background_music = [
#	load("res://Assets/Sound/music/make it easy.mp3"),
#	load("res://Assets/Sound/music/edutainment.mp3")
#]
#var background_music_names = [
#	"Make it easy",
#	"Edutainment"
#]
##
#var demos = [
#	load("res://Assets/Sound/Demos/8 bit adventure.mp3"),
#	load("res://Assets/Sound/Demos/8 bit creature.mp3"),
#	load("res://Assets/Sound/Demos/a productive day.mp3"),
#	load("res://Assets/Sound/Demos/arcade.mp3"),
#	load("res://Assets/Sound/Demos/chance time.mp3"),
#	load("res://Assets/Sound/Demos/clock tower.mp3"),
#	load("res://Assets/Sound/Demos/dance of the baobabs.mp3"),
#	load("res://Assets/Sound/Demos/happy donk.mp3"),
#	load("res://Assets/Sound/Demos/pixel squirrel.mp3"),
#	load("res://Assets/Sound/Demos/pixel wave.mp3")
#]

signal song_skipped
signal song_finished
var index = 0
#var demo_names = [
#	"8 bit adventure",
#	"8 bit creature",
#	"a productive day",
#	"arcade",
#	"chance time",
#	"clock tower",
#	"dance of the baobabs",
#	"happy donk",
#	"pixel squirrel",
#	"pixel wave"
#]


