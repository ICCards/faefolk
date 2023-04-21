extends Node2D

@rpc
func add_item_drop(item: Array, pos: Vector2): pass

@rpc
func player_picked_up_item(data): pass


@rpc
func add_item_to_inventory(name,data):
	PlayerData.pick_up_item(data["n"], data["q"], data["h"])
	Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up(data["n"], data["q"])
