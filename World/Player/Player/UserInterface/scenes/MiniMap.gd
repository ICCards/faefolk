extends Node2D


onready var dot    = $Dot
onready var grass  = get_node("/root/World/GeneratedTiles/GreenGrassTiles")
onready var player = get_node("/root/World/Players/" + Server.player_id)

enum Tiles { GROUND, ROOF, FOG }

func _ready():
	$FogTimer.connect("timeout", self, "update_fog")
	generate()

func generate():
	# add starting tiles to minimap
	for cell in grass.get_used_cells():
		var tile = grass.get_cellv(cell)
		$Map.set_cellv(cell, 0)

	# fill outer borders
	var rect = $Map.get_used_rect()
	var buffer = 15  # how far tiles extends beyond edge of map

	for x in range(rect.position.x - buffer, rect.end.x + buffer):
		for y in range(rect.position.y - buffer, rect.end.y + buffer):
			var cell = Vector2(x,y)
			if $Map.get_cellv(cell) == -1:
				$Map.set_cellv(cell, 0)

	dot.position = player.position/8
	$FogTimer.start()

# move the player in the minimap
# minimap is 8x smaller, 32/4 = 8
func _process(delta):
	dot.position = player.position/8

# update the fog of war
func update_fog():
	var player_pos = grass.world_to_map(player.position)

	# how far players can see in fog
	var seex = 8
	var seey = 6

	for x in range(-seex, seex):
		for y in range(-seey, seey):
			var cell = player_pos + Vector2(x,y)
			var tile = $Map.get_cellv(cell)
			$Fog.set_cellv(cell, tile)
