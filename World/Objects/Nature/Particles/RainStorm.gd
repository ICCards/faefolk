extends Node2D


var random_rain_storm_position

func _ready():
	randomize()
	position = Vector2(rand_range(0, 32000), rand_range(0, 32000))
	initiate_rain_storm()

func initiate_rain_storm():
	randomize()
	random_rain_storm_position = Vector2(rand_range(0, 32000), rand_range(0, 32000))
	yield(get_tree().create_timer(rand_range(60, 180)), "timeout")
	initiate_rain_storm()

func _process(delta):
	if Server.isLoaded and not PlayerInventory.viewMapMode:
		visible = true
		position = position.move_toward(random_rain_storm_position, delta * 10)
	else:
		visible = false
