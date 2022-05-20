extends Node2D
class_name Ninja

var position_of_object

onready var _player
onready var _nav2d


var _nav_path : PoolVector2Array;
var _nav_has_destination :bool;

func _ready():
	_player = get_node("/root/Cave/Player");
	_nav2d = get_node("/root/Cave/CaveNavigation")
	print(_player);
	pass
	
export var MAX_SPEED = 150;
var _velocity :Vector2;
	

func initialize(pos):
	position_of_object = pos

func _physics_process(delta):
	if(_nav_has_destination):
		var prev_position = self.get_global_position();
		_move_along_path(MAX_SPEED * delta);
		_velocity = prev_position.direction_to(self.get_global_position()) / delta;
		_face_velocity_direction();
		
func _move_along_path(dist : float)->void:
	var position = self.get_global_position();
	for i in range(_nav_path.size()):
		var dist_to_next_node = position.distance_to(_nav_path[0]);
		if(dist < dist_to_next_node):
			self.global_position = position.linear_interpolate(_nav_path[0], dist / dist_to_next_node);
			break;
		else:
			dist -= dist_to_next_node;
			position = _nav_path[0];
			_nav_path.remove(0);
			
func _face_velocity_direction():
	var rotation_radian :float = atan2(_velocity.y, _velocity.x);
	self.set_rotation(rotation_radian);


