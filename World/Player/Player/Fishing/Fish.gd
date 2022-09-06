extends Node2D

var movement_speed 
var min_movement_time 
var max_movement_time 
var min_distance 
var max_distance 

var min_position = 88
var max_position = -26

var rng = RandomNumberGenerator.new()
var fish_data
var is_mini_game_over = false

func _ready():
	get_fish()

func get_fish():
	fish_data = FishData.returnOceanDay()
	$Fish.texture = load("res://Assets/Images/inventory_icons/Fish/" + fish_data[0] + ".png")
	set_difficulty("medium")
	#set_difficulty("medium")

func start():
	plan_move()
	
func stop_fish_movement():
	$Tween.stop_all()
	is_mini_game_over = true

func plan_move():
	var target = rand_range(min_position, max_position)
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		target = rand_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

	
func move(target):
	if not is_mini_game_over:
		randomize()
		$Tween.interpolate_property(self, "position", position, target, movement_speed+rand_range(-1,1), Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.start()
		
		$MoveTimer.set_wait_time(rand_range(min_movement_time, max_movement_time))
		$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	queue_free()

func _on_MoveTimer_timeout():
	if Util.chance(20):
		move_to_top_or_bottom()
	else:
		plan_move()
	
func move_to_top_or_bottom():
	if self.position.y < 31:
		move(Vector2(self.position.x, max_position))
	else:
		move(Vector2(self.position.x, min_position))

func set_difficulty(difficulty):
	match difficulty:
		"very easy":
			movement_speed = 3.25
			min_movement_time = 1.0
			max_movement_time = 2.5
			min_distance = 30
			max_distance = 90
		"easy":
			movement_speed = 3
			min_movement_time = 0.5
			max_movement_time = 2.0
			min_distance = 30
			max_distance = 100
		"medium":
			movement_speed = 2.75
			min_movement_time = 0.5
			max_movement_time = 2.0
			min_distance = 30
			max_distance = 115
		"hard":
			movement_speed = 2.25
			min_movement_time = 0.2
			max_movement_time = 1.5
			min_distance = 50
			max_distance = 150
