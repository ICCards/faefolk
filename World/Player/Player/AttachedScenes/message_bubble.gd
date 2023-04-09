extends Control

@export var message = "sup"
@export var redraw: bool : set = initialize

func _ready():
	initialize()


func initialize(value = null) -> void:
	$Message.text = message
	await get_tree().process_frame
	set_bubble_size()


func set_bubble_size():
	if $Message.size.x <= 440:
		$Bg.size = Vector2(26,16)
	else:
		$Bg.size = Vector2(26,16)
