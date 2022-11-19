extends YSort

onready var LightningLine = preload("res://World/Objects/Misc/LightningLine.tscn")
onready var WindBoss = preload("res://World/Caves/Bosses/WindBoss.tscn")
onready var Bat = preload("res://World/Enemies/Slime/Bat.tscn")

var is_changing_scene: bool = false
var nav_node
var cave_chest_id = "level 1, room 7"
var bat_count = 0
var NUM_SLIMES = 0
var NUM_SPIDERS = 0
var NUM_SKELETONS = 0

var cave_data = {
	"ore": {},
	"large_ore": {},
	"tall_grass": {},
	"mushroom": {}
}

func _ready():
	randomize()
	nav_node = $Navigation2D
	Tiles.cave_wall_tiles = $Tiles/Walls
	Tiles.valid_tiles = $Tiles/ValidTiles
	Server.world = self
	BuildCaveLevel.build()
	Server.isLoaded = true
	yield(get_tree().create_timer(2.0), "timeout")
	spawn_boss()
	
func advance_up_cave_level():
	if not is_changing_scene:
		Server.player_node.destroy()
		is_changing_scene = true
		for enemy in $Enemies.get_children():
			enemy.destroy()
		SceneChanger.goto_scene("res://World/Caves/Level 1/Cave 9/Cave 9.tscn")

	
func _on_SpawnBatTimer_timeout():
	if bat_count < 5:
		var locs = $Tiles/BatSpawnTiles.get_used_cells()
		locs.shuffle()
		var bat = Bat.instance()
		$Enemies.add_child(bat)
		bat.position = locs[0]*32
		bat_count += 1

func spawn_boss():
	var boss = WindBoss.instance()
	boss.position = Vector2(rand_range(20,40), rand_range(20,40))*32
	$Enemies.add_child(boss)

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
