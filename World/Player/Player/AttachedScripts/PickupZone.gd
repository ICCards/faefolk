extends Area2D


func _ready():
	pass 
	
var items_in_range = {}

func _on_PickupZone_body_entered(body):
	if PlayerDataHelpers.can_item_be_added_to_inventory(body.item_name, body.item_quantity):
		items_in_range[body] = body
	else:
		Server.player_node.user_interface.get_node("ItemPickUpDialogue").item_picked_up("Inventory full!", null)


func _on_PickupZone_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)
