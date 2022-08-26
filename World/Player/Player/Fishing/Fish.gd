extends Node2D

var season
var setting
var time

var movement_speed 
var movement_time

var min_distance
var max_distance

var min_position = 20
var max_position = 290

var rng = RandomNumberGenerator.new()

func _ready():
	get_fish()
	plan_move()


func get_fish():
	rng.randomize()
	var temp_fish = JsonData.fish_data.keys()[rng.randi_range(0, JsonData.fish_data.keys().size() - 1)]
	print(JsonData.fish_data.keys()[rng.randi_range(0, JsonData.fish_data.keys().size() - 1)])
	JsonData.fish_data[temp_fish]["Location"]

func plan_move():
	var target = rand_range(min_position, max_position)
	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		target = rand_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

	
func move(target):
	$Tween.interpolate_property(self, "position", position, target, movement_speed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()
	
	$MoveTimer.set_wait_time(movement_time)
	$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	queue_free()

func _on_MoveTimer_timeout():
	plan_move()
