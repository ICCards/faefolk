extends KinematicBody2D

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var _timer: Timer = $Timer
onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D

var is_sleeping: bool = true
var destroyed: bool = false
var frozen: bool = false
var _velocity := Vector2.ZERO
var health: int = Stats.BUNNY_HEALTH
var running_state: bool = false
var random_pos
var MAX_MOVE_DISTANCE: float = 500.0
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var tornado_node

func _ready(): 
	hide()
	randomize()
	set_random_attributes()
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))
	orbit_radius = rand_range(30,70)
	#navigation_agent.set_navigation_map(get_world_2d().navigation_map)

func set_random_attributes():
	randomize()
	Images.BunnyVariations.shuffle()
	$AnimatedSprite.frames = Images.BunnyVariations[0]
	var randomRadiusScale = rand_range(0.5,2.0)
	$DetectPlayer/CollisionShape2D.scale = Vector2(randomRadiusScale, randomRadiusScale)
	_timer.wait_time = rand_range(2.5, 5.0)
	if Util.chance(50):
		$AnimatedSprite.flip_h = true

func get_random_pos():
	if running_state:
		var randomDistance = rand_range(350, 450)
		if Util.chance(25):
			random_pos = Vector2(randomDistance, randomDistance)
		elif Util.chance(25):
			random_pos = Vector2(-randomDistance, randomDistance)
		elif Util.chance(25):
			random_pos = Vector2(randomDistance, -randomDistance)
		else:
			random_pos = Vector2(-randomDistance, -randomDistance)
	else:
		random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	return position + random_pos


func _update_pathfinding() -> void:
	navigation_agent.set_target_location(get_random_pos())


func _physics_process(delta):
	if tornado_node:
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if not visible or destroyed:
		return
	if is_sleeping:
		$AnimatedSprite.play("sleep")
		return
	if navigation_agent.is_navigation_finished():
		$AnimatedSprite.play("idle")
		return
	$AnimatedSprite.play("walk")
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	navigation_agent.set_velocity(_velocity)
	if _get_direction_string(_velocity) == "Right":
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true


func move(velocity: Vector2) -> void:
	if tornado_node:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif running_state:
		_velocity = move_and_slide(velocity*1.5)
	else:
		_velocity = move_and_slide(velocity)
	

func _get_direction_string(veloctiy) -> String:
	if _velocity.x > 0:
		return "Right"
	return "Left"


func hit(tool_name):
	if is_sleeping:
		is_sleeping = false
	start_run_state()
	health -= Stats.return_sword_damage(tool_name)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health <= 0 and not destroyed:
		set_physics_process(false)
		destroyed = true
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		yield($AnimatedSprite, "animation_finished")
		$AnimationPlayer.play("death")
		InstancedScenes.intitiateItemDrop("raw filet", position, 1)
		yield($AnimationPlayer, "animation_finished")
		yield(get_tree().create_timer(6.0), "timeout")
		queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "explosion spell":
		hit(area.tool_name)
	if area.tool_name == "ice projectile":
		start_frozen_state()
	if area.tool_name == "lingering tornado":
		tornado_node = area
	
	
func start_frozen_state():
	$FrozenTimer.stop()
	$FrozenTimer.start()
	$AnimatedSprite.modulate = Color("00c9ff")
	frozen = true
	
func start_run_state():
	running_state = true
	$RunStateTimer.start()
	_timer.wait_time = 2.0
	_update_pathfinding()


func _on_DetectPlayer_area_entered(area):
	is_sleeping = false

func _on_RunStateTimer_timeout():
	running_state = false
	_timer.wait_time = rand_range(2.5, 5.0)


func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()


func _on_FrozenTimer_timeout():
	$AnimatedSprite.modulate = Color("ffffff")
	frozen = false
