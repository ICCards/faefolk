extends KinematicBody2D

onready var genius = $AnimatedSprite
onready var player : Player
onready var _nav2d : Navigation2D
onready var _line2D : Line2D
onready var targetArea = $GeniusTerritory
onready var petrolTimer = $BeehaveRoot/Timer

const speed = 50
const petrol_range = 50

#petrol state
export var spawn_location = Vector2.ZERO


func _ready():
	player = get_node("/root/Cave/Player");
	_nav2d = get_node("/root/Cave/CaveNavigation")
	_line2D = get_node("/root/Cave/Line2D")
	spawn_location = self.get_global_position()
	pass


# func _physics_process(delta):
# 	var player_distance = get_dist_to_player()
# 	if(player_distance > 100):
# 		genius.play("walk")
# 	if(player_distance < 100):
# 		move_along_path(SPEED * delta)
# 	pass

func move_along_path(dist : float)->void:
	genius.play("run")
	rotate_towards_player()
	var position = self.get_global_position();
	var _nav_path = _nav2d.get_simple_path(self.get_global_position(), player.get_global_position(), false)
	for i in range(_nav_path.size()):
		var dist_to_next_node = position.distance_to(_nav_path[0]);
		if(dist < dist_to_next_node):
			self.global_position = position.linear_interpolate(_nav_path[0], dist / dist_to_next_node);
			break;
		else:
			dist -= dist_to_next_node;
			position = _nav_path[0];
			_nav_path.remove(0);


func petrol_to_path(dist : float, point: Vector2)->void:
	genius.play("walk")
	rotate_towards_player()
	var position = self.get_global_position();
	var _nav_path = _nav2d.get_simple_path(self.get_global_position(), point, false)
	for i in range(_nav_path.size()):
		var dist_to_next_node = position.distance_to(_nav_path[0]);
		if(dist < dist_to_next_node):
			self.global_position = position.linear_interpolate(_nav_path[0], dist / dist_to_next_node);
			break;
		else:
			dist -= dist_to_next_node;
			position = _nav_path[0];
			_nav_path.remove(0);
			
func rotate_towards_player():
	print(genius.rotation)
	print(self.rotation)
	genius.rotation = lerp(genius.rotation, player.get_global_position().angle(), 0.1)
	
			
func move_towards_position(target_position: Vector2, delta: float):
	rotate_towards_player()
	self.position += self.position.direction_to(target_position) * delta * speed
	
# func get_dist_to_player():
# 	var geniusCord = self.get_global_position()
# 	var playerCord = _player.get_global_position()
# 	var distance = geniusCord.distance_to(playerCord)
# 	return distance;
