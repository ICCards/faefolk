extends Node2D


@rpc
func mob_hit(data):pass

@rpc
func destroy_mob(data): 
	get_node(str(data["id"])).destroy(data)

@rpc
func update_mob_hit(data): 
	get_node(str(data["id"])).mob_hit(data)
