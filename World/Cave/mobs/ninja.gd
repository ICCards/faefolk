extends Node2D
class_name Ninja

var position_of_object


onready var player1 = get_node("/root/Cave/Player");
onready var player2 = get_tree().get_root().get_node("/root/Cave/Player");
onready var x = get_tree().get_root();
var Player;


func _ready():
	Player = get_node("/root/Cave/Player");
	pass
	

func initialize(pos):
	position_of_object = pos
	isAccess()
	
func isAccess():
	#print(player1)
	#print(player2, x)
	print(Player)
