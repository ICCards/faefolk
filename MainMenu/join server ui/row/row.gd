extends HBoxContainer

var server_name
var current_players
var max_players
var pvp
var ping

func _ready():
	$Name.text = str(server_name)
	$Players.text = str(current_players) + " / " + str(max_players)
	$PvP.text = str(pvp)
	$Ping.text = str(ping)


func _on_button_pressed():
	if not current_players == max_players:
		get_node("../../../../../").join(name)
