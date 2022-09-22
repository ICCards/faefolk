extends Node

var music_volume = 50
var sound_volume = 50
var ambient_volume = 50
var footstep_volume = 50

signal volume_change
signal footsteps_sound_change

func _ready():
	set_music_volume(music_volume)
	set_sound_volume(sound_volume)
	set_ambient_volume(ambient_volume)
	set_footstep_volume(footstep_volume)

func set_music_volume(val):
	music_volume = val
	emit_signal("volume_change")

func set_sound_volume(val):
	sound_volume = val
	emit_signal("volume_change")
	
func set_ambient_volume(val):
	ambient_volume = val
	emit_signal("volume_change")

func set_footstep_volume(val):
	footstep_volume = val
	emit_signal("volume_change")
	
func return_adjusted_sound_db(category, init_sound):
	return -80
#	if category == "music":
#		var progress = music_volume / 100
#		if progress == 0.5:
#			return init_sound
#		elif progress < 0.5:
#			var dis_to_mute =  -(80 + init_sound)
#			return (init_sound + ((1 - (progress * 2)) * dis_to_mute))
#		elif progress > 0.5:
#			return init_sound + ((progress - 0.5) / 5) * 150
#	elif category == "sound":
#		var progress = sound_volume / 100
#		if progress == 0.5:
#			return init_sound
#		elif progress < 0.5:
#			var dis_to_mute =  -(80 + init_sound)
#			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
#		elif progress > 0.5:
#			return init_sound + ((progress - 0.5) / 5) * 150
#	elif category == "ambient":
#		var progress = ambient_volume / 100
#		if progress == 0.5:
#			return init_sound
#		elif progress < 0.5:
#			var dis_to_mute =  -(80 + init_sound)
#			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
#		elif progress > 0.5:
#			return init_sound + ((progress - 0.5) / 5) * 150
#	elif category == "footstep":
#		var progress = footstep_volume / 100
#		if progress == 0.5:
#			return init_sound
#		elif progress < 0.5:
#			var dis_to_mute =  -(60 + init_sound)
#			return init_sound + ((1 - (progress * 2)) * dis_to_mute)
#		elif progress > 0.5:
#			return init_sound + ((progress - 0.5) / 5) * 150


### Handles switching footsteps sound

var current_footsteps_sound = wood_footsteps




### Sound effects ##
var wood_footsteps = preload("res://Assets/Sound/Sound effects/Footsteps/wood footsteps.mp3")
var dirt_footsteps = preload("res://Assets/Sound/Sound effects/Footsteps/dirt footsteps.mp3")
var stone_footsteps = preload("res://Assets/Sound/Sound effects/Footsteps/stone footsteps.mp3")
var swimming = preload("res://Assets/Sound/Sound effects/Footsteps/swimming.mp3")

var button_hover = preload("res://Assets/Sound/Sound effects/UI/button hover.mp3")
var button_select = preload("res://Assets/Sound/Sound effects/UI/button select.mp3")

var pick_up_item = preload("res://Assets/Sound/Sound effects/UI/pick up item.mp3")

var place_object = preload("res://Assets/Sound/Sound effects/Building/place object.mp3")

var pick_up_house_object = preload("res://Assets/Sound/Sound effects/UI/pick up house object.mp3")
var put_down_house_object = preload("res://Assets/Sound/Sound effects/UI/put down house object.mp3")

var door_open = preload("res://Assets/Sound/Sound effects/Door/door open.mp3")
var door_close = preload("res://Assets/Sound/Sound effects/Door/door close.mp3")

var chest_open = preload("res://Assets/Sound/Sound effects/chest/open.mp3")

var ore_hit = [
	preload("res://Assets/Sound/Sound effects/Ore/Ore hit 1.mp3"),
	preload("res://Assets/Sound/Sound effects/Ore/Ore hit 2.mp3"),
	preload("res://Assets/Sound/Sound effects/Ore/Ore hit 3.mp3"),
	]

var ore_break = [
	preload("res://Assets/Sound/Sound effects/Ore/Ore break 1.mp3"),
	preload("res://Assets/Sound/Sound effects/Ore/Ore break 2.mp3"),
	preload("res://Assets/Sound/Sound effects/Ore/Ore break 3.mp3")
	]

var tree_hit = [
	preload("res://Assets/Sound/Sound effects/Tree/Tree hit 1.mp3"),
	preload("res://Assets/Sound/Sound effects/Tree/Tree hit 2.mp3"),
	preload("res://Assets/Sound/Sound effects/Tree/Tree hit 3.mp3")
]

var sword_whoosh = [
	preload("res://Assets/Sound/Sound effects/Sword/sword whoosh.mp3"),
	preload("res://Assets/Sound/Sound effects/Sword/sword whoosh 2.mp3"),
]

var tree_break = preload("res://Assets/Sound/Sound effects/Tree/Falling tree.mp3")
var stump_break = preload("res://Assets/Sound/Sound effects/Tree/Stump break.mp3")
var tool_break = preload("res://Assets/Sound/Sound effects/objects/tool break.mp3")

var bear_grown = [
	preload("res://Assets/Sound/Sound effects/Animals/Bear/Groan/ES_Monster Bear Groan 1 - SFX Producer.mp3"),
	preload("res://Assets/Sound/Sound effects/Animals/Bear/Groan/ES_Monster Bear Groan 2 - SFX Producer.mp3"),
	preload("res://Assets/Sound/Sound effects/Animals/Bear/Groan/ES_Monster Bear Groan 3 - SFX Producer.mp3")
]


### Ambient ###
var rain = preload("res://Assets/Sound/Sound effects/Ambience/ES_Rain Downpour 2 - SFX Producer.mp3")
var nature = preload("res://Assets/Sound/Sound effects/Ambience/ES_Forest 7 - SFX Producer.mp3")
var blizzard = preload("res://Assets/Sound/Sound effects/Ambience/ES_Blizzard Forest 5 - SFX Producer.mp3") 

var fire_start = preload("res://Assets/Sound/Sound effects/Fire/start.mp3")
var fire_crackle = preload("res://Assets/Sound/Sound effects/Fire/crackle.mp3")

### Music ###
var title_music = preload("res://Assets/Sound/music/563_full_wobble-dance_0157.mp3")
var background_music = [
	preload("res://Assets/Sound/music/125_full_make-it-easy_0159.mp3"),
	preload("res://Assets/Sound/music/136_full_edutainment_0162.mp3")
]
