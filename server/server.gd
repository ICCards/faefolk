extends Node


var isLoaded = false
var player_node
var world
var player_id
var connected_peer_ids = []


func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	Server.world.spawn_player(peer_id)
#	if peer_id == multiplayer.get_unique_id():
#		local_player_character = pla

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)

@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)
