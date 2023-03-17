extends Sprite2D



func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await get_tree().create_timer(0.5).timeout 
	call_deferred("queue_free")


