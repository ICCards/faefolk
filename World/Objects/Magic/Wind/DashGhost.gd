extends Sprite2D

var tween = get_tree().create_tween()


func _ready():
	tween.tween_property(self, "modulate:a", 0.0, 0.5)


func _on_Tween_tween_completed(object, key):
	queue_free()
