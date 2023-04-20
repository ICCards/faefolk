extends Node2D

@rpc
func add_item_drop(item: Array, pos: Vector2): pass

@rpc
func player_picked_up_item(data): pass
