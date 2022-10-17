extends KinematicBody2D

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var _timer: Timer = $Timer
onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D

var is_eating: bool = false
var is_dead: bool = false
var _velocity := Vector2.ZERO
var health: int = Stats.DUCK_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 500.0
var random_pos

func _ready():
	hide()
	set_random_attributes()
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))
	#navigation_agent.set_navigation(get_node("/root/TestScene/Navigation2D"))

func set_random_attributes():
	randomize()
	Images.DuckVariations.shuffle()
	$AnimatedSprite.frames = Images.DuckVariations[0]
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
	if Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.ocean_tiles.get_cellv(Tiles.ocean_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position


func _physics_process(delta):
	if not visible or is_dead or is_eating:
		return
	if navigation_agent.is_navigation_finished():
		if Util.chance(20):
			is_eating = true
			$AnimatedSprite.play("eat")
			yield($AnimatedSprite, "animation_finished")
			is_eating = false
		else:
			is_eating = true
			$AnimatedSprite.play("idle")
			yield(get_tree().create_timer(rand_range(1.0, 4.0)), "timeout")
			is_eating = false
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
	if running_state:
		_velocity = move_and_slide(velocity*1.5)
	else:
		_velocity = move_and_slide(velocity)


func _get_direction_string(velocitiy) -> String:
	if velocitiy.x > 0:
		return "Right"
	return "Left"


func _update_pathfinding() -> void:
	navigation_agent.set_target_location(get_random_pos())

func _on_HurtBox_area_entered(area):
	is_eating = false
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	start_run_state()
	deduct_health(area.tool_name)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health <= 0 and not is_dead:
		set_physics_process(false)
		is_dead = true
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("death")
		yield($AnimatedSprite, "animation_finished")
		$AnimationPlayer.play("death")
		intitiateItemDrop("raw wing", Vector2(0,0))
		yield($AnimationPlayer, "animation_finished")
		queue_free()


func deduct_health(tool_name):
	match tool_name:
		"wood sword":
			health -= Stats.WOOD_SWORD_DAMAGE
		"stone sword":
			health -= Stats.STONE_SWORD_DAMAGE
		"bronze sword":
			health -= Stats.BRONZE_SWORD_DAMAGE
		"iron sword":
			health -= Stats.IRON_SWORD_DAMAGE
		"gold sword":
			health -= Stats.GOLD_SWORD_DAMAGE
		"arrow":
			health -= Stats.ARROW_DAMAGE
	
func start_run_state():
	running_state = true
	$RunStateTimer.start()
	_timer.wait_time = 2.0
	_update_pathfinding()
	
	
func intitiateItemDrop(item, pos):
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item, 1)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos + Vector2(rand_range(-12, 12), 0)


func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()


func _on_RunStateTimer_timeout():
	running_state = false
	_timer.wait_time = rand_range(2.5, 5.0)
