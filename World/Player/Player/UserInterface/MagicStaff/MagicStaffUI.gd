extends Control

var selected_spell: int = 1
var selected_staff = ""


var COOL_DOWN_PERIOD_1: int = 1
var COOL_DOWN_PERIOD_2: int = 5
var COOL_DOWN_PERIOD_3: int = 10
var COOL_DOWN_PERIOD_4: int = 20

func initialize(_staff):
	selected_spell = 1
	selected_staff = _staff
	set_selected_spell()
	set_bgs()
	
func set_bgs():
	match selected_staff:
		"lightning staff":
			$Bg/btn1.texture_normal = Images.lighting_staff[0]
			$Bg/btn2.texture_normal = Images.lighting_staff[1]
			$Bg/btn3.texture_normal = Images.lighting_staff[2]
			$Bg/btn4.texture_normal = Images.lighting_staff[3]


func set_selected_spell():
	match selected_spell:
		1:
			$SelectedBg.rect_position.x = 0
		2:
			$SelectedBg.rect_position.x = 24
		3:
			$SelectedBg.rect_position.x = 48
		4:
			$SelectedBg.rect_position.x = 72


func start_spell_cooldown():
	match selected_spell:
		1:
			$Tween.interpolate_property(get_node("Cooldown"+str(selected_spell)), "rect_size",
				Vector2(20,20), Vector2(20,0), COOL_DOWN_PERIOD_1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		2:
			$Tween.interpolate_property(get_node("Cooldown"+str(selected_spell)), "rect_size",
				Vector2(20,20), Vector2(20,0), COOL_DOWN_PERIOD_2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		3:
			$Tween.interpolate_property(get_node("Cooldown"+str(selected_spell)), "rect_size",
				Vector2(20,20), Vector2(20,0), COOL_DOWN_PERIOD_3,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		4:
			$Tween.interpolate_property(get_node("Cooldown"+str(selected_spell)), "rect_size",
				Vector2(20,20), Vector2(20,0), COOL_DOWN_PERIOD_4,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func validate_spell_cooldown():
	return get_node("Cooldown"+str(selected_spell)).rect_size.y == 0

func _on_1_pressed():
	selected_spell = 1
	set_selected_spell()

func _on_2_pressed():
	selected_spell = 2
	set_selected_spell()

func _on_4_pressed():
	selected_spell = 4
	set_selected_spell()

func _on_3_pressed():
	selected_spell = 3
	set_selected_spell()
