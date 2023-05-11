extends Control

@export var message = ""
@export var redraw: bool : set = initialize


func _ready():
	modulate = Color("ffffff00")

func initialize(value = null) -> void:
	$DestroyTimer.stop()
	$DestroyTimer.start(5)
	$AnimationPlayer.stop()
	modulate = Color("ffffff")
	$Message.text = value
	await get_tree().process_frame
	set_bubble_size()

func set_bubble_size():
	var lines = $Message.get_line_count()
	var chars = $Message.text.length()
	if lines == 1:
		if chars <= 5:
			$Bg.size = Vector2(26,16)
			$Bg.position = Vector2(-13,-16)
		elif chars <= 8:
			$Bg.size = Vector2(38,16)
			$Bg.position = Vector2(-19,-16)
		elif chars <= 11:
			$Bg.size = Vector2(44,16)
			$Bg.position = Vector2(-22,-16)
		else:
			$Bg.size = Vector2(70,16)
			$Bg.position = Vector2(-35,-16)
	elif lines == 2:
		$Bg.size = Vector2(70,26)
		$Bg.position = Vector2(-35,-26)
	else:
		$Bg.size = Vector2(70,36)
		$Bg.position = Vector2(-35,-36)


func _on_destroy_timer_timeout():
	$AnimationPlayer.play("fade out")
