extends Node
var window = JavaScript.get_interface("window")
#var window
#var connect_callback = JavaScript.create_callback(self, "_connect")

#func _ready():
#	pass

func _login(args):
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	print("login message")
	print(js_event)
	# Call preventDefault and set the `returnValue` property of the DOM event.
	#js_event.preventDefault()
	#js_event.returnValue = ''
func _connect(args):
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	print("login message")
	print(js_event)
	# Call preventDefault and set the `returnValue` property of the DOM event.
	#js_event.preventDefault()
	#js_event.returnValue = ''


func login(callback):
	window.login(Server.player_id).then(callback)

func connect_plug(callback):
	window.connect_mainnet().then(callback)

func getUsername(principal,callback):
	window.getICNSName(principal).then(callback)

#func _on_request_completed(result, response_code, headers, body):
var test_json_conv = JSON.new()
test_json_conv.parse(body.get_string_from_utf8())
#	var json = test_json_conv.get_data()
#	print(json.result)
