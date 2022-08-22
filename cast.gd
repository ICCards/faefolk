extends Node2D


onready var progress = $ProgressBar
onready var line2d = $Line2D

var is_going_up = true
var is_casted = false
export var cast_point = Vector2(0,0)
export var end_point = Vector2(100, 20)
export var midPt1 = Vector2(100, 0)
export var midPt2 = Vector2(100, 0)


func _ready():
	setLinePointsToBezierCurve(line2d, cast_point, midPt1, midPt2, end_point)
#	setLinePointsToBezierCurve(line2d, cast_point, Vector2(0, 25), Vector2(0, 25), end_point)

func _physics_process(delta):
	if not is_casted:
		if Input.is_action_pressed("mouse_click"):
			if is_going_up:
				progress.value += 2
				if progress.value == progress.max_value:
					is_going_up = false
			else:
				progress.value -= 2
				if progress.value == progress.min_value:
					is_going_up = true
		elif Input.is_action_just_released("mouse_click"):
			end_point = Vector2(progress.value*5, 25)
			setLinePointsToBezierCurve(line2d, cast_point, midPt1, midPt2, end_point)
			#is_casted = true
		var r = range_lerp($ProgressBar.value, 10, 100, 1, 0)
		var g = range_lerp($ProgressBar.value, 10, 50, 0, 1)
		progress.modulate = Color(r, g, 0)

func setLinePointsToBezierCurve(line: Line2D, a: Vector2, postA: Vector2, preB: Vector2, b: Vector2):
	var curve := Curve2D.new()
	curve.add_point(a, Vector2.ZERO, postA)
	curve.add_point(b, preB, Vector2.ZERO)
	line.points = curve.get_baked_points()
