extends MultiplayerSynchronizer


@export var position: Vector2:
	set(val):
		if is_multiplayer_authority():
			position = val
		else:
			get_parent().position = val
