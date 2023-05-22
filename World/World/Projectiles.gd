extends Node2D


@rpc
func single_arrow_shot(data): pass

@rpc 
func play_wind_spell(data): pass


@rpc 
func play_dash_effect(data):
	var players = Server.world.get_node("Players").get_children()
	for player in players:
		if player.name == data["p_id"]:
			player.magic.play_dash_effect()
			return

@rpc
func play_whirlwind_effect(data):
	var players = Server.world.get_node("Players").get_children()
	for player in players:
		if player.name == data["p_id"]:
			player.magic.play_whirlwind_effect(data)
			return
