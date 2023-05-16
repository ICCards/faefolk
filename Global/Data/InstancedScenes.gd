extends Node

@onready var ExplosionParticles = load("res://World/Objects/Nature/Effects/ExplosionParticles.tscn")
@onready var Bird = load("res://World/Animals/BirdFlyingFromTree.tscn")
@onready var LeavesFallEffect = load("res://World/Objects/Nature/Effects/LeavesFallingEffect.tscn")
@onready var TrunkHitEffect = load("res://World/Objects/Nature/Effects/TrunkHitEffect.tscn")
@onready var OreHitEffect = load("res://World/Objects/Nature/Effects/OreHitEffect.tscn")
@onready var PlayerHitEffect = load("res://World/Player/Player/AttachedScenes/PlayerHitEffect/PlayerHitEffect.tscn")
@onready var ItemDrop = load("res://InventoryLogic/ItemDrop.tscn")
@onready var WateringCanEffect = load("res://World/Objects/Nature/Effects/WateringCan.tscn")
@onready var HoedDirtEffect = load("res://World/Objects/Nature/Effects/HoedDirt.tscn") 
@onready var UpgradeBuildingEffect = load("res://World/Objects/Nature/Effects/UpgradeBuilding.tscn")
@onready var RemoveBuildingEffect = load("res://World/Objects/Nature/Effects/RemoveBuilding.tscn")
@onready var LightningLine = load("res://World/Objects/Misc/LightningLine.tscn")
@onready var EatingParticles = load("res://World/Player/Player/AttachedParticles/Eating/EatingParticles.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func add_eating_particles(item_name):
	var eating_paricles = EatingParticles.instantiate()
	eating_paricles.item_name = item_name
	Server.player_node.add_child(eating_paricles)


func intitiateItemDrop(item_name: String, pos: Vector2, amount: int): 
		for _i in range(amount):
			Server.world.get_node("ItemDrops").rpc_id(1,"add_item_drop", [item_name,1,null], pos+Vector2(rng.randf_range(-6, 6), rng.randf_range(-6, 6)))
#		Server.world.get_node("ItemDrops").rpc_id(1,"")
#		var itemDrop = ItemDrop.instantiate()
#		itemDrop.initItemDropType(item_name)
#		Server.world.get_node("ItemDrops").call_deferred("add_child", itemDrop)
#		itemDrop.global_position = pos + Vector2(rng.randi_range(-6, 6), rng.randi_range(-6, 6))

func initiateInventoryItemDrop(item: Array, pos: Vector2): 
	Server.world.get_node("ItemDrops").rpc_id(1,"add_item_drop",item,pos)
#	var itemDrop = ItemDrop.instantiate()
#	itemDrop.initItemDropType(item[0], item[1], item[2])
#	Server.world.get_node("ItemDrops").call_deferred("add_child", itemDrop)
#	itemDrop.global_position = pos + Vector2(rng.randi_range(-6, 6), rng.randi_range(-6, 6))


### Trees ###
func initiateLeavesFallingEffect(variety: String, pos: Vector2):
	if Server.world:
		var adjusted_leaves_falling_pos = Vector2.ZERO
		if variety == "evergreen" or variety == "apple" or variety == "cherry":
			adjusted_leaves_falling_pos = Vector2(0,0)
		else:
			adjusted_leaves_falling_pos = Vector2(0,-10)
		var leavesEffect = LeavesFallEffect.instantiate()
		leavesEffect.variety = variety
		Server.world.call_deferred("add_child", leavesEffect)
		leavesEffect.global_position = adjusted_leaves_falling_pos + pos

func initiateTreeHitEffect(variety: String, effect_type: String, pos: Vector2):
	var trunkHitEffect = TrunkHitEffect.instantiate()
	trunkHitEffect.init(variety, effect_type)
	Server.world.call_deferred("add_child", trunkHitEffect)
	trunkHitEffect.global_position = pos

func initiateBirdEffect(pos: Vector2):
	if Util.chance(33):
		if Util.chance(50):
			rng.randomize()
			var bird = Bird.instantiate()
			bird.fly_position = pos + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
			Server.world.call_deferred("add_child", bird)
			bird.global_position = pos + Vector2(0,-60)
		else:
			for i in range(2):
				rng.randomize()
				var bird = Bird.instantiate()
				bird.fly_position = pos + Vector2(rng.randi_range(-40000, 40000), rng.randi_range(-40000, 40000))
				Server.world.call_deferred("add_child", bird)
				bird.global_position = pos + Vector2(0,-60)

### Ores ###

func initiateOreHitEffect(variety: String, effect_type: String, pos: Vector2):
	var oreHitEffect = OreHitEffect.instantiate()
	oreHitEffect.variety = variety
	oreHitEffect.effect_type = effect_type
	Server.world.call_deferred("add_child", oreHitEffect)
	oreHitEffect.global_position = pos
	

func initiateExplosionParticles(pos: Vector2):
	var explosion = ExplosionParticles.instantiate()
	Server.world.call_deferred("add_child", explosion)
	explosion.global_position = pos + Vector2(0,32)
	
func player_hit_effect(amt: int, pos: Vector2, is_player_hit = false):
	var effect = PlayerHitEffect.instantiate()
	effect.is_player_hit = is_player_hit
	effect.amount = amt
	effect.position = pos
	Server.world.call_deferred("add_child", effect)
	
	
# Effects #
func play_watering_can_effect(loc):
	var wateringCanEffect = WateringCanEffect.instantiate()
	wateringCanEffect.global_position = Vector2i(loc*16) + Vector2i(8,8)
	Server.world.call_deferred("add_child", wateringCanEffect)
	
func play_hoed_dirt_effect(loc):
	var hoedDirtEffect = HoedDirtEffect.instantiate()
	hoedDirtEffect.global_position = Vector2i(loc*16) + Vector2i(8,10)
	Server.world.call_deferred("add_child", hoedDirtEffect)

func play_upgrade_building_effect(loc):
	pass # FUCKED
#	var upgradeBuildingEffect = UpgradeBuildingEffect.instantiate()
#	upgradeBuildingEffect.global_position = loc*32 + Vector2i(16,16)
#	Server.world.call_deferred("add_child", upgradeBuildingEffect)
	
func play_remove_building_effect(loc):
	var removeBuildingEffect = RemoveBuildingEffect.instantiate()
	removeBuildingEffect.global_position = Vector2i(loc*16) + Vector2i(8,8)
	Server.world.call_deferred("add_child", removeBuildingEffect)
	
func find_mst(nodes):
	var path = AStar3D.new()
	if not nodes.is_empty():
		path.add_point(path.get_available_point_id(), nodes.pop_front())
		
		while nodes:
			var min_dist = INF
			var min_p = null 
			var p = null  
			for p1 in path.get_points():
				p1 = path.get_point_position(p1)
				for p2 in nodes:
					if p1.distance_to(p2) < min_dist:
						min_dist = p1.distance_to(p2)
						min_p = p2
						p = p1
			var n = path.get_available_point_id()
			path.add_point(n, min_p)
			path.connect_points(path.get_closest_point(p), n)
			nodes.erase(min_p)
		return path
	
func draw_mst_lightning_lines(nodes):
	var path = find_mst(nodes)
	var current_lines = []
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				if not current_lines.has([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]) and not current_lines.has([Vector2(cp.x, cp.y), Vector2(pp.x, pp.y)]):
					var lightning_line = LightningLine.instantiate()
					current_lines.append([Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)])
					lightning_line.points = [Vector2(pp.x, pp.y), Vector2(cp.x, cp.y)]
					Server.world.call_deferred("add_child", lightning_line)
