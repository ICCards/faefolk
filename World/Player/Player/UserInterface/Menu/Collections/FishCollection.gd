extends GridContainer



func initialize():
	show()
	for fish in CollectionsData.fish.keys():
		if CollectionsData.fish[fish] > 0:
			get_node(fish).modulate = Color("ffffff") # unlocked
			get_node(fish).material.set_shader_param("flash_modifier", 0)
		else:
			get_node(fish).modulate = Color("50ffffff") # locked
			get_node(fish).material.set_shader_param("flash_modifier", 1)

func entered_item_area(item_name):
	get_parent().item = item_name
	$Tween.interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.1, 1.1), 0.075,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func exited_item_area(item_name):
	get_parent().item = null
	if has_node(item_name):
		$Tween.interpolate_property(get_node(item_name), "rect_scale",
		get_node(item_name).rect_scale, Vector2(1.0, 1.0), 0.075,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_albacore_mouse_entered():
	entered_item_area("albacore")
func _on_albacore_mouse_exited():
	exited_item_area("albacore")

func _on_anchovy_mouse_entered():
	entered_item_area("anchovy")
func _on_anchovy_mouse_exited():
	exited_item_area("anchovy")

func _on_angler_mouse_entered():
	entered_item_area("angler")
func _on_angler_mouse_exited():
	exited_item_area("angler")

func _on_betta_mouse_entered():
	entered_item_area("betta")
func _on_betta_mouse_exited():
	exited_item_area("betta")

func _on_blowfish_mouse_entered():
	entered_item_area("blowfish")
func _on_blowfish_mouse_exited():
	exited_item_area("blowfish")

func _on_catfish_mouse_entered():
	entered_item_area("catfish")
func _on_catfish_mouse_exited():
	exited_item_area("catfish")

func _on_cisco_mouse_entered():
	entered_item_area("cisco")
func _on_cisco_mouse_exited():
	exited_item_area("cisco")
	
func _on_clownfish_mouse_entered():
	entered_item_area("clownfish")
func _on_clownfish_mouse_exited():
	exited_item_area("clownfish")

func _on_crab_mouse_entered():
	entered_item_area("crab")
func _on_crab_mouse_exited():
	exited_item_area("crab")

func _on_dorado_mouse_entered():
	entered_item_area("dorado")
func _on_dorado_mouse_exited():
	exited_item_area("dorado")

func _on_eel_mouse_entered():
	entered_item_area("eel")
func _on_eel_mouse_exited():
	exited_item_area("eel")

func _on_goldfish_mouse_entered():
	entered_item_area("goldfish")
func _on_goldfish_mouse_exited():
	exited_item_area("goldfish")

func _on_halibut_mouse_entered():
	entered_item_area("halibut")
func _on_halibut_mouse_exited():
	exited_item_area("halibut")

func _on_koi_mouse_entered():
	entered_item_area("koi")
func _on_koi_mouse_exited():
	exited_item_area("koi")

func _on_lingcod_mouse_entered():
	entered_item_area("lingcod")
func _on_lingcod_mouse_exited():
	exited_item_area("lingcod")

func _on_nelma_mouse_entered():
	entered_item_area("nelma")
func _on_nelma_mouse_exited():
	exited_item_area("nelma")

func _on_octopus_mouse_entered():
	entered_item_area("octopus")
func _on_octopus_mouse_exited():
	exited_item_area("octopus")

func _on_purple_carp_mouse_entered():
	entered_item_area("purple carp")
func _on_purple_carp_mouse_exited():
	exited_item_area("purple carp")

func _on_purple_salmon_mouse_entered():
	entered_item_area("purple salmon")
func _on_purple_salmon_mouse_exited():
	exited_item_area("purple salmon")

func _on_red_salmon_mouse_entered():
	entered_item_area("red salmon")
func _on_red_salmon_mouse_exited():
	exited_item_area("red salmon")

func _on_seaweed_mouse_entered():
	entered_item_area("seaweed")
func _on_seaweed_mouse_exited():
	exited_item_area("seaweed")

func _on_shrimp_mouse_entered():
	entered_item_area("shrimp")
func _on_shrimp_mouse_exited():
	exited_item_area("shrimp")

func _on_siberian_whitefish_mouse_entered():
	entered_item_area("siberian whitefish")
func _on_siberian_whitefish_mouse_exited():
	exited_item_area("siberian whitefish")

func _on_tilapia_mouse_entered():
	entered_item_area("tilapia")
func _on_tilapia_mouse_exited():
	exited_item_area("tilapia")
