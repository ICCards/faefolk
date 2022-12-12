extends Node2D

func _process(delta):
	if not PlayerData.viewMapMode and Server.player_node:
		show()
		var forest = get_node("/root/World/GeneratedTiles/DarkGreenGrassTiles")
		if forest.get_cellv(forest.world_to_map(Server.player_node.position)) != -1:
			$FallingLeaf.emitting = true
		else: 
			$FallingLeaf.emitting = false
	else:
		hide()
