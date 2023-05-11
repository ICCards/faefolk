extends Control


@onready var Row = load("res://MainMenu/join server ui/row/row.tscn")


func _ready():
	for i in range(50):
		var row = Row.instantiate()
		row.server_name = "Server name!"
		row.ip_address = randi()
		row.max_players = randi_range(1,5)*10
		row.current_players = randi_range(0,row.max_players)
		row.pvp = Util.chance(50)
		$VBoxContainer/Body/ScrollContainer/Rows.add_child(row)


func join(ip_address):
	pass
