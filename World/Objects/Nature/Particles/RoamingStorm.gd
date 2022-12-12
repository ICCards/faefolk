extends Node2D


var random_storm_position
var is_snow_storm = false


var MIN_DIST = 4000
var MAX_DIST = 28000


func _ready():
	randomize()
	position = Vector2(rand_range(MIN_DIST, MAX_DIST), rand_range(MIN_DIST, MAX_DIST))
	initiate_storm()

func initiate_storm():
	randomize()
	random_storm_position = Vector2(rand_range(MIN_DIST, MAX_DIST), rand_range(MIN_DIST, MAX_DIST))
	$IdleTimer.start(rand_range(60, 180))

func _physics_process(delta):
	if Server.isLoaded and not PlayerData.viewMapMode:
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


func _on_IdleTimer_timeout():
	initiate_storm()
