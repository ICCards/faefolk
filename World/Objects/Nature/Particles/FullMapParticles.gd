extends Node2D

func _process(delta):
	if Server.isLoaded and not PlayerInventory.viewMapMode and has_node("/root/World/Players/" + Server.player_id):
		visible = true
		var forest = get_node("/root/World/GeneratedTiles/DarkGreenGrassTiles")
		var player = get_node("/root/World/Players/" + Server.player_id)
		if forest.get_cellv(forest.world_to_map(player.position)) != -1:
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		visible = false
