extends Node2D

func _ready():
	spawn()
	
func spawn():
	Tiles.remove_valid_tiles(Tiles.valid_tiles.world_to_map(position), Vector2(3,2))
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("spawn")

func _on_Timer_timeout():
	$AnimatedSprite.play("remove")
	yield($AnimatedSprite, "animation_finished")
	Tiles.add_valid_tiles(Tiles.valid_tiles.world_to_map(position), Vector2(3,2))
	queue_free()
