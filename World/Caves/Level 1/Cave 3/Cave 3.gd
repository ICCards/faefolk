extends YSort


onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var bat_count = 0
var maximum_bats = 4
var cave_chest_id = "level 1, room 3"
var NUM_SLIMES = 4
var NUM_SPIDERS = 3
var NUM_SKELETONS = 1

var cave_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}

func _ready():
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true

func advance_up_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = false
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 2/Cave 2.tscn")

func advance_down_cave_level():
	if not is_changing_scene:
		BuildCaveLevel.is_player_going_down = true
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 4/Cave 4.tscn")
	
func _on_SpawnBatTimer_timeout():
	if bat_count < maximum_bats:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		bat_count += 1

func draw_mst(path):
	var current_lines = []
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				if not current_lines.has([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]) and not current_lines.has([Vector2(cp.x, cp.y), Vector2(pp.x, pp.y)]):
					var lightning_line = LightningLine.instance()
					current_lines.append([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)])
					lightning_line.points = [Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]
					add_child(lightning_line)
