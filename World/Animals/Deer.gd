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
var changed_direction: bool = false
var health: int = Stats.DEER_HEALTH
var KNOCKBACK_AMOUNT = 300

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
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.global_position)
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())
	
func get_random_pos():
	random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	if Tiles.deep_ocean_tiles.get_cellv(Tiles.deep_ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.deep_ocean_tiles.get_cellv(Tiles.deep_ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position
	
func move(velocity: Vector2) -> void:
	if not dying and not attacking:
		_velocity = move_and_slide(velocity)

func _physics_process(delta):
	if dying:
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
	if not changed_direction:
		if abs(_velocity.x) >= abs(_velocity.y):
			if _velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_wait()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_wait()
		else:
			if _velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_wait()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_wait()

func set_change_direction_wait():
	changed_direction = true
	yield(get_tree().create_timer(0.5), "timeout")
	changed_direction = false


func _on_HurtBox_area_entered(area):
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 100
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	$HurtBox/AnimationPlayer.play("hit")
	health -= Stats.return_sword_damage(area.tool_name)
	if health <= 0 and not dying:
		dying = true
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("death")
		yield($AnimationPlayer, "animation_finished")
		queue_free()



func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()
