extends Node2D

var movement_speed 
var min_movement_time 
var max_movement_time 
var min_distance 
var max_distance 

var min_position = 83
var max_position = -21

var rng = RandomNumberGenerator.new()
var fish_data

func _ready():
	get_fish()

func get_fish():
	fish_data = FishData.returnOceanDay()
	$Fish.texture = load("res://Assets/Images/inventory_icons/Fish/" + fish_data[0] + ".png")
	set_difficulty(fish_data[1])
	#set_difficulty("medium")

func start():
	plan_move()

func plan_move():
	var target = rand_range(min_position, max_position)
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		target = rand_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

	
func move(target):
	randomize()
	$Tween.interpolate_property(self, "position", position, target, movement_speed+rand_range(-1,1), Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	$MoveTimer.set_wait_time(rand_range(min_movement_time, max_movement_time))
	$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	queue_free()

func _on_MoveTimer_timeout():
	plan_move()

func set_difficulty(difficulty):
	match difficulty:
		"easy":
			movement_speed = 3
			min_movement_time = 0.5
			max_movement_time = 2.5
			min_distance = 30
			max_distance = 120
		"medium":
			movement_speed = 2.75
			min_movement_time = 0.35
			max_movement_time = 2.0
			min_distance = 40
			max_distance = 130
		"hard":
			movement_speed = 2.25
			min_movement_time = 0.2
			max_movement_time = 1.5
			min_distance = 50
			max_distance = 150
