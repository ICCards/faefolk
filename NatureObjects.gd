extends Node2D


@rpc("call_local", "any_peer", "unreliable")
func hit(id,tool_name):
	print(id)
	for node in self.get_children():
		if node.name == id:
			node.hit(tool_name)
			return
