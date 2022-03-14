extends Node2D

onready var animPlayer = $AnimationPlayer 

var treeHits: int = 3
onready var player = get_node("/root/World/YSort/Player/Player")


var isAnimActive: bool = false
func _on_Hurtbox_area_entered(area):
	if (treeHits == 0):
		isAnimActive = false
		if ((player.get_position().x * 4) >= get_position().x):
			animPlayer.play("tree_fall_left")
		if ((player.get_position().x * 4) < get_position().x):
			animPlayer.play("tree_fall_right")
	if (treeHits != 0):
		var LeavesEffect = load("res://Globals/LeavesFalling.tscn")
		var leavesEffect = LeavesEffect.instance()
		var world = get_tree().current_scene
		world.add_child(leavesEffect)
		leavesEffect.global_position = global_position
		if ((player.get_position().x * 4) >= get_position().x):
			if (!isAnimActive):
				animPlayer.play("tree_hit_from_right")
				isAnimActive = true
				yield(animPlayer, "animation_finished" )
				treeHits = treeHits - 1	
				isAnimActive = false
		if ((player.get_position().x * 4) < get_position().x):
			if (!isAnimActive):
				animPlayer.play("tree_hit_from_left")
				isAnimActive = true
				yield(animPlayer, "animation_finished" )
				treeHits = treeHits - 1
				isAnimActive = false

