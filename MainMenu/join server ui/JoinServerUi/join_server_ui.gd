extends Control


@onready var ServerRow = load("res://MainMenu/join server ui/row/row.tscn")

func _ready():
	var output = []
	OS.execute('ping', ['-c', '1', 'godotengine.org'], output)
	var time_slice_index = output[0].findn("time=")
	print(time_slice_index)
	var start = time_slice_index + 5
	var ping = output[0].substr(start,10)
	for i in range(50):
		var row = ServerRow.instantiate()
		row.server_name = "Server name!"
		row.name = "test ip"
		row.max_players = randi_range(1,5)*10
		row.current_players = randi_range(0,row.max_players)
		row.pvp = Util.chance(50)
		row.ping = ping
		$VBoxContainer/Body/ScrollContainer/Rows.add_child(row)


func join(ip_address):
	print(ip_address)
