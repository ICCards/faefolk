extends MultiplayerSynchronizer


@export var position: Vector2:
	set(val):
		if is_multiplayer_authority():
			position = val
		else:
			get_parent().position = val

@export var animation: String:
	set(val):
		if is_multiplayer_authority():
			animation = val
		else:
			get_parent().animation = val

@export var tool_name: String:
	set(val):
		if is_multiplayer_authority():
			tool_name = val
		else:
			get_parent().tool_name = val
			
#@export var current_animation: String:
#	set(val):
#		if is_multiplayer_authority():
#			current_animation = val
#		else:
#			get_parent().animation_player.current_animation = val
