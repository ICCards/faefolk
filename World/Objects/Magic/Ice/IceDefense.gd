extends AnimatedSprite


func _ready():
	show()
	animation = "start"
	play()
	yield(self, "animation_finished")
	animation = "idle"
	play()
	yield(self, "animation_finished")
	animation = "end"
	play()
	yield(self, "animation_finished")
	get_parent().emit_signal("spell_finished")
	queue_free()
