extends Control

@onready var chatLog = $VBoxContainer/RichTextLabel
@onready var inputLabel = $VBoxContainer/HBoxContainer/Label
@onready var inputField = $VBoxContainer/HBoxContainer/LineEdit


func _ready():
	initialize_chat_history()
	inputField.connect("text_submitted",Callable(self,"text_submitted"))
	

var message_history = []

func ReceiveMessage(player_id, message):
	message_history.append([player_id, message])
	Server.world.get_node("Players/" + str(player_id)).DisplayMessageBubble(message)
	Server.world.get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/ChatBox").ReceiveMessage(str(player_id), message)
	

func initialize_chat_history():
	for i in range(message_history.size()):
		if str(message_history[i][0]) == str(Server.player_id):
			add_message(message_history[i][0], message_history[i][1], '#1359ff')
		else:
			add_message(message_history[i][0], message_history[i][1], '#ffffff')


#func ReceiveMessage(player_id, message):
#	if str(player_id) == Server.player_id:
#		add_message(player_id, message, '#00e7ff')
#	else:
#		add_message(player_id, message, '#ffffff')


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()
			

func text_submitted(text):
	if text != "":
		add_message(Server.player_node.name, text, '#1359ff')
#		var data =  {"u": Server.username, "d": text}
#		var message = Util.toMessage("SEND_MESSAGE",data)
#		Server._client.get_peer(1).put_packet(message)
#		inputField.text = ''
#		inputField.release_focus()
	
func add_message(username, text, color):
	chatLog.text += '\n' 
	chatLog.text += '[color=' + color + ']'
	chatLog.text += '[' + str(username).substr(0,5) + ']: '
	chatLog.text += text
	chatLog.text += '[/color]'


func _on_LineEdit_focus_entered():
	PlayerData.chatMode = true


func _on_LineEdit_focus_exited():
	PlayerData.chatMode = false


func _on_TextureButton_pressed():
	$ColorRect.visible = !$ColorRect.visible
	$VBoxContainer.visible = !$VBoxContainer.visible
	if $ColorRect.visible == false:
		$TextureButton.texture_normal = load("res://Assets/Images/Misc/right arrow.png")
	else:
		$TextureButton.texture_normal = load("res://Assets/Images/Misc/left arrow.png")
