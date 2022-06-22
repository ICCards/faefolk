extends Node


func ReceiveMessage(player_id, message):
	print(message)
	Server.world.get_node("Players/" + Server.player_id + "/Camera2D/UserInterface/ChatBox").ReceiveMessage(player_id, message)
