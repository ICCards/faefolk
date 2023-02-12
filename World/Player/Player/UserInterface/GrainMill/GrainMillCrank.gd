extends Sprite2D


var dragging = false
var temp = 0
#func _ready():
#	get_node("Area2D").connect("input_event",Callable(self,"_on_area_input_event"))
#	set_process_input(true)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		# Start dragging when the user presses the mouse button over the clickable area
		dragging = event.pressed
	
func _input(event):
	if dragging:
		if event is InputEventMouseMotion:
			var motion = event.relative
			var new_pos = get_global_mouse_position()
			var prev_pos = new_pos - motion
			var center = get_global_position()
			# Calculate the angular motion of the crank based checked the arc made with the mouse
			var angle = (prev_pos - center).angle_to(new_pos - center)
			rotate(angle)
		elif event is InputEventMouseButton and event.button_pressed == false:
			# Stop dragging when the user releases the mouse button
			dragging = false
			$SoundEffects.stream_paused = true
	


func rotate(angle):
	if angle > 0:
		temp += 4
		rotation_degrees += 4
		if temp > 500:
			get_parent().craft()
			temp = 0
		$SoundEffects.stream_paused = false
	else:
		$SoundEffects.stream_paused = true

func _on_Area2D_mouse_exited():
	pass
	#dragging = false
