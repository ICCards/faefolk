extends KinematicBody2D

onready var _idle_timer: Timer = $IdleTimer
onready var _chase_timer: Timer = $ChaseTimer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer

var player = Server.player_node
var direction: String = "down"
var dying: bool = false
var attacking: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 500.0

var state = IDLE

enum {
	IDLE,
	WALK,
	RUN,
	ATTACK
}

func _ready():
	randomize()
	_idle_timer.wait_time = rand_range(4.0,6.0)
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	navigation_agent.connect("velocity_computed", self, "move") 

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.global_position)
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())
	
func get_random_pos():
	random_pos = Vector2(rand_range(-300, 300), rand_range(-300, 300))
	if Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position
	
func move(velocity: Vector2) -> void:
	if not dying:
		velocity = move_and_slide(velocity)

func _physics_process(delta):
	if state == ATTACK:
		return
	if navigation_agent.is_navigation_finished():
		animation_player.play("idle_" + direction)
		return
	set_direction()
	animation_player.play("run_" + direction)
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	navigation_agent.set_velocity(_velocity)
	
func set_direction():
	if abs(_velocity.x) >= abs(_velocity.y):
		if _velocity.x >= 0:
			direction = "right"
		else:
			direction = "left"
	else:
		if _velocity.y >= 0:
			direction = "down"
		else:
			direction = "up"

func _on_HurtBox_area_entered(area):
	start_chase_state()
	
func start_chase_state():
	pass
