extends KinematicBody2D

onready var genius = $AnimatedSprite
onready var _player : Player
onready var _nav2d : Navigation2D
onready var _line2D : Line2D

var nav_path: PoolVector2Array

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
var direction = 1

func _ready():
	_player = get_node("/root/Cave/Player");
	_nav2d = get_node("/root/Cave/CaveNavigation")
	_line2D = get_node("/root/Cave/Line2D")
	pass


func _physics_process(delta):
	var player_distance = get_dist_to_player()
	if(player_distance > 100):
		genius.play("walk")
	if(player_distance < 100):
		_move_along_path(SPEED * delta)
	pass

func _move_along_path(dist : float)->void:
	genius.play("run")
	var position = self.get_global_position();
	var _nav_path = _nav2d.get_simple_path(self.get_global_position(), _player.get_global_position(), false)
	for i in range(_nav_path.size()):
		var dist_to_next_node = position.distance_to(_nav_path[0]);
		if(dist < dist_to_next_node):
			self.global_position = position.linear_interpolate(_nav_path[0], dist / dist_to_next_node);
			break;
		else:
			dist -= dist_to_next_node;
			position = _nav_path[0];
			_nav_path.remove(0);
	
func get_dist_to_player():
	var geniusCord = self.get_global_position()
	var playerCord = _player.get_global_position()
	var distance = geniusCord.distance_to(playerCord)
	return distance;
