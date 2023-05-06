extends Control

@export var message = "sup bro my names max"
@export var redraw: bool : set = initialize

func initialize(value = null) -> void:
	$Message.text = message
	await get_tree().process_frame
	set_bubble_size()

func set_bubble_size():
	var lines = $Message.get_line_count()
	var chars = $Message.text.length()
	if lines == 1:
		if chars <= 5:
			$Bg.size = Vector2(32,17)
			$Bg.position = Vector2(-16,-17)
		elif chars <= 7:
			$Bg.size = Vector2(53,17)
			$Bg.position = Vector2(-27,-17)
		else:
			$Bg.size = Vector2(71,17)
			$Bg.position = Vector2(-36,-17)
	elif lines == 2:
		$Bg.size = Vector2(71,28)
		$Bg.position = Vector2(-36,-28)
	else:
		$Bg.size = Vector2(71,40)
		$Bg.position = Vector2(-36,-40)
