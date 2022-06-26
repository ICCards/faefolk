extends Node


var message_history = []


func ReceiveMessage(player_id, message):
	message_history.append([player_id, message])
	Server.world.get_node("Players/" + str(player_id)).DisplayMessageBubble(message)
	Server.world.get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/ChatBox").ReceiveMessage(str(player_id), message)
