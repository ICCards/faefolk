extends Node2D


var random_storm_position
var is_snow_storm = false

func _ready():
	randomize()
	position = Vector2(rand_range(0, 32000), rand_range(0, 32000)) #Vector2( 4000, 4000) #Vector2(rand_range(0, 4000), rand_range(0, 4000))
	initiate_storm()

func initiate_storm():
	randomize()
	random_storm_position = Vector2(rand_range(0, 32000), rand_range(0, 32000))
	yield(get_tree().create_timer(rand_range(60, 180)), "timeout")
	initiate_storm()

func _physics_process(delta):
	if Server.isLoaded and not PlayerInventory.viewMapMode:
		visible = true
		position = position.move_toward(random_storm_position, delta * 10)
		var snow = get_node("/root/World/GeneratedTiles/SnowTiles")
		if snow.get_cellv(snow.world_to_map(position)) == -1:
			is_snow_storm = false
			$Snow.emitting = false
			$RainStorm/Rain.emitting = true
			$RainStorm/RainOnFloor.emitting = true
		else:
			is_snow_storm = true
			$Snow.emitting = true
			$RainStorm/Rain.emitting = false
			$RainStorm/RainOnFloor.emitting = false
	else:
		visible = false
