extends Sprite2D



func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)


func _on_Tween_tween_completed(object, key):
	queue_free()
