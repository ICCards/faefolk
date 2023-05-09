extends Node


@export var position: Vector2
@export var current_footsteps_sound: String = ""
@export var animation: String = "idle_down"
@export var tool_name: String = ""
@export var footstep_stream_paused: bool
@export var holding_item_name: String = ""

func _physics_process(delta):
	#if $Networking.is_multiplayer_authority():
		position = get_parent().position
		current_footsteps_sound = get_parent().current_footsteps_sound
		tool_name = get_parent().tool_name
		footstep_stream_paused = get_parent().footstep_stream_paused
		holding_item_name = get_parent().holding_item_name
		animation = get_parent().animation
