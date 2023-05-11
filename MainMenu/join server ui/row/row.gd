extends HBoxContainer

var ip_address
var server_name
var current_players
var max_players
var pvp

func _ready():
	name = str(ip_address)
	$Name.text = str(server_name)
	$Players.text = str(current_players) + " / " + str(max_players)
	$PvP.text = str(pvp)
	$Ping.text = str(randi())


func _on_button_pressed():
	if not current_players == max_players:
		get_node("../../../../../").join(name)
