extends Control

onready var chatLog = $VBoxContainer/RichTextLabel
onready var inputLabel = $VBoxContainer/HBoxContainer/Label
onready var inputField = $VBoxContainer/HBoxContainer/LineEdit


var groups = [
	{'name': 'Self', 'color': '#1c71a4'},
	{'name': 'Other', 'color': '#f1c234'},
	
]

var group_index = 0


func _ready():
	inputField.connect("text_entered", self, "text_entered")
	
func ReceiveMessage(player_id, message):
	add_message(player_id, message, '#ffffff')

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			inputField.grab_focus()
		if event.pressed and event.scancode == KEY_ESCAPE:
			inputField.release_focus()
			

func text_entered(text):
	if text != "":
		var data = {"d": text}
		var message = Util.toMessage("SEND_MESSAGE",data)
		Server._client.get_peer(1).put_packet(message)
		inputField.text = ''
	
func add_message(username, text, color):
	chatLog.bbcode_text += '\n' 
	chatLog.bbcode_text += '[color=' + color + ']'
	chatLog.bbcode_text += '[' + str(username).substr(0,4) + ']: '
	chatLog.bbcode_text += text
	chatLog.bbcode_text += '[/color]'


func _on_LineEdit_focus_entered():
	PlayerInventory.chatMode = true


func _on_LineEdit_focus_exited():
	PlayerInventory.chatMode = false
