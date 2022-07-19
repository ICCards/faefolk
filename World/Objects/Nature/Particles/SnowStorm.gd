extends Node2D



var random_snow_storm_position
var MAX_SPEED = 10

func _ready():
	randomize()
	position = Vector2(rand_range(0, 32000), rand_range(0, 32000))
	initiate_snow_storm()

func _process(delta):
	if Server.isLoaded and not PlayerInventory.viewMapMode:
		visible = true
		position = position.move_toward(random_snow_storm_position, delta * MAX_SPEED)
	else:
		visible = false

func initiate_snow_storm():
	randomize()
	random_snow_storm_position = Vector2(rand_range(0, 32000), rand_range(0, 32000))
	yield(get_tree().create_timer(rand_range(60, 180)), "timeout")
	initiate_snow_storm()
