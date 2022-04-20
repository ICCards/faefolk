extends YSort

onready var TreeObject = preload("res://World/Objects/TreeObject.tscn")
onready var BranchObject = preload("res://World/Objects/TreeBranchObject.tscn")
onready var StumpObject = preload("res://World/Objects/TreeStumpObject.tscn")
onready var OreObject = preload("res://World/Objects/OreObjectLarge.tscn")
onready var SmallOreObject = preload("res://World/Objects/SmallOreObject.tscn")

onready var world = get_tree().current_scene
var rng = RandomNumberGenerator.new()

func _ready():
	for i in range(10):
		rng.randomize()
		var treeObject = TreeObject.instance()
		call_deferred("add_child", treeObject)
		treeObject.position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 2600))
	for i in range(10):
		rng.randomize()
		var branchObject = BranchObject.instance()
		call_deferred("add_child", branchObject)
		branchObject.position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 2600))
	for i in range(10):
		rng.randomize()
		var stumpObject = StumpObject.instance()
		call_deferred("add_child", stumpObject)
		stumpObject.position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 2600))
	for i in range(10):
		rng.randomize()
		var oreObject = OreObject.instance()
		call_deferred("add_child", oreObject)
		oreObject.position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 2600))
	for i in range(10):
		rng.randomize()
		var smallOreObject = SmallOreObject.instance()
		call_deferred("add_child", smallOreObject)
		smallOreObject.position = Vector2(rng.randi_range(600, 1600), rng.randi_range(600, 2600))
