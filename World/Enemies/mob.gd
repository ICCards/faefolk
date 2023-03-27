extends Node2D

@onready var Bear = load("res://World/Animals/Bear.tscn")
@onready var Bunny = load("res://World/Animals/Bunny.tscn")
@onready var Duck = load("res://World/Animals/Duck.tscn")
@onready var Boar = load("res://World/Animals/Boar.tscn")
@onready var Deer = load("res://World/Animals/Deer.tscn")
@onready var Wolf = load("res://World/Animals/Wolf.tscn")

var map
var id

func _ready():
	spawn_mob()

func spawn_mob():
	var animal_name = map["animal"][id]["n"]
	var location = map["animal"][id]["l"]
	match animal_name:
		"bunny":
			var animal = Bunny.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.variety = map["animal"][id]["v"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(16, 16)
			call_deferred("add_child", animal)
		"duck":
			var animal = Duck.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.variety = map["animal"][id]["v"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(16, 16)
			call_deferred("add_child", animal)
		"bear":
			var animal = Bear.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(8,8)
			call_deferred("add_child", animal)
		"boar":
			var animal = Boar.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(16, 16)
			call_deferred("add_child", animal)
		"wolf":
			var animal = Wolf.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(16, 16)
			call_deferred("add_child", animal)
		"deer":
			var animal = Deer.instantiate()
			animal.name = id
			animal.health = map["animal"][id]["h"]
			animal.global_position = Tiles.valid_tiles.map_to_local(location) + Vector2(8, 8)
			call_deferred("add_child", animal)


func _physics_process(delta):
	$VisibleOnScreenNotifier2D.position = get_children()[1].position

func _on_visible_on_screen_notifier_2d_screen_entered():
	self.get_children()[1].screen_entered()

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.get_children()[1].screen_exited()
