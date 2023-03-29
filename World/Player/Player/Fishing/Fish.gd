extends Node2D

var movement_speed 
var min_movement_time 
var max_movement_time 
var min_distance 
var max_distance 

var alt_move_chance
var game_timer

var min_position = 88
var max_position = -26

var rng = RandomNumberGenerator.new()
var fish_data
var is_mini_game_over = false

func _ready():
	get_fish()

func get_fish():
#	if Server.world.name == "Overworld":
	fish_data = FishData.returnOceanDay()
#	else:
#		fish_data = FishData.returnCaveFish()
	$Fish.texture = load("res://Assets/Images/inventory_icons/Fish/" + fish_data[0] + ".png")
	set_difficulty(fish_data[1])

func start():
	plan_move()
	
func stop_fish_movement():
	is_mini_game_over = true

func plan_move():
	var target = randf_range(min_position, max_position)
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		target = randf_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

	
func move(target):
	if not is_mini_game_over:
		randomize()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target, movement_speed+randf_range(-0.75,0.75))
		$MoveTimer.set_wait_time(randf_range(min_movement_time, max_movement_time))
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
	print("FISH DIFFICULTY " + difficulty)
	match difficulty:
		"very easy":
			movement_speed = 3.25
			min_movement_time = 1.0
			max_movement_time = 2.0
			min_distance = 10
			max_distance = 80
			game_timer = 30.0
			alt_move_chance = 10.0
		"easy":
			movement_speed = 3
			min_movement_time = 0.75
			max_movement_time = 1.75
			min_distance = 20
			max_distance = 90
			game_timer = 25.0
			alt_move_chance = 10.0
		"medium1":
			movement_speed = 2.75
			min_movement_time = 0.8
			max_movement_time = 1.8
			min_distance = 30
			max_distance = 105
			game_timer = 20.0
			alt_move_chance = 20.0
		"medium2":
			movement_speed = 2.85
			min_movement_time = 0.6
			max_movement_time = 1.6
			min_distance = 20
			max_distance = 100
			game_timer = 14.0
			alt_move_chance = 15.0
		"hard":
			movement_speed = 2.6
			min_movement_time = 0.7
			max_movement_time = 1.5
			min_distance = 30
			max_distance = 100
			game_timer = 18.0
			alt_move_chance = 18.0
		"very hard":
			movement_speed = 2.5
			min_movement_time = 0.6
			max_movement_time = 1.5
			min_distance = 40
			max_distance = 105
			game_timer = 16.0
			alt_move_chance = 20.0
