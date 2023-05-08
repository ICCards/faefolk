extends Control

@onready var chatLog = $VBoxContainer/RichTextLabel
@onready var inputLabel = $VBoxContainer/HBoxContainer/Label
@onready var inputField = $VBoxContainer/HBoxContainer/LineEdit


func _ready():
#	initialize_chat_history()
	inputField.connect("text_submitted",Callable(self,"text_submitted"))
	

var message_history = []

func ReceiveMessage(player_id, message):
	message_history.append([player_id, message])
	Server.world.get_node("Players/" + str(player_id)).DisplayMessageBubble(message)
	Server.world.get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/ChatBox").ReceiveMessage(str(player_id), message)
	

#func initialize_chat_history():
#	for i in range(message_history.size()):
#		if str(message_history[i][0]) == str(Server.player_id):
#			add_message(message_history[i][0], message_history[i][1], '#1359ff')
#		else:
#			add_message(message_history[i][0], message_history[i][1], '#ffffff')


func add_message(data):
	var player_id = data["player_id"]
	var message = data["m"]
	if player_id == Server.player_node.name:
		display_message(player_id, message, '#00e7ff')
	else:
		display_message(player_id, message, '#ffffff')

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			inputField.grab_focus()
		if event.pressed and event.keycode == KEY_ESCAPE:
			inputField.release_focus()
			

func text_submitted(text):
	if text != "":
		var data =  {"player_id": Server.player_node.name, "m": text}
		Server.world.rpc_id(1,"send_message",data)
		inputField.text = ''
		inputField.release_focus()
	
func display_message(username, text, color):
	chatLog.text += '\n' 
	chatLog.text += '[color=' + color + ']'
	chatLog.text += '[' + str(username).substr(0,5) + ']: '
	chatLog.text += text
	chatLog.text += '[/color]'


func _on_LineEdit_focus_entered():
	inputField.placeholder_text = ""
	PlayerData.chatMode = true

func _on_LineEdit_focus_exited():
	inputField.text = ""
	inputField.placeholder_text ="Press ENT to enter / ESC to exit"
	PlayerData.chatMode = false


func _on_TextureButton_pressed():
	$ColorRect.visible = !$ColorRect.visible
	$VBoxContainer.visible = !$VBoxContainer.visible
	if $ColorRect.visible == false:
		$TextureButton.texture_normal = load("res://Assets/Images/Misc/right arrow.png")
	else:
		$TextureButton.texture_normal = load("res://Assets/Images/Misc/left arrow.png")
