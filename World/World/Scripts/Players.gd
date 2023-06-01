extends Node2D



# chat messages
@rpc
func send_message(data): pass

@rpc 
func receive_message(data): 
	Server.player_node.user_interface.get_node("ChatBox").add_message(data)
	for player in self.get_children():
		if player.name == data["player_id"]:
			player.get_node("AttachedText/MessageBubble").initialize(data["m"])
			return
