class_name Bunny
extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D
onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")
var player_spotted: bool = false
var random_idle_pos = null
var in_idle_state: bool = false
var is_in_sight: bool = false
var is_dead: bool = false
var path: Array = []
var player
const SPEED: int = 150
var worldNavigation
var is_sleeping = true

signal target_reached
signal path_changed(path)

enum AnimationState {
	IDLE = 0,
	MOVE = 1,
	SLEEP = 2,
	DEATH = 3
}

var AnimationNames = {
	AnimationState.MOVE:"walk",
	AnimationState.IDLE:"idle",
	AnimationState.SLEEP:"sleep",
	AnimationState.DEATH:"death"
}


var rng = RandomNumberGenerator.new()

export(float) var MAX_SPEED = 200


var velocity = Vector2.ZERO
var state = AnimationState.MOVE
var last_move_velocity = Vector2.ZERO
var current_animation = null
var move_direction = Vector2.ZERO
var did_arrive = false


func swim():
	state = AnimationState.SWIM
	
func idle():
	state = AnimationState.IDLE
	velocity = Vector2.ZERO
	
func sleep():
	state = AnimationState.SLEEP
	velocity = Vector2.ZERO

func _ready():
	rng.randomize()
	Images.BunnyVariations.shuffle()
	$AnimatedSprite.frames = Images.BunnyVariations[0]
	if Util.chance(50):
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("sleep")


func _on_NavigationAgent2D_path_changed():
	emit_signal("path_changed", navigation_agent.get_nav_path())

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	if not _arrived_at_location():
		velocity = move_and_slide(safe_velocity)
	elif not did_arrive:
		did_arrive = true
		emit_signal("path_changed", [])
		emit_signal("target_reached")

func _arrived_at_location() -> bool:
	return navigation_agent.is_navigation_finished()

func _physics_process(delta):
	if not is_sleeping:
		if not visible:
			return
		var move_direction = position.direction_to(navigation_agent.get_next_location())
		velocity = move_direction * MAX_SPEED
		look_at_direction(move_direction)
		_play_animation(state)
		navigation_agent.set_velocity(velocity)
	
func look_at_direction(direction:Vector2) -> void:
	direction = direction.normalized()
	move_direction = direction
	if current_animation != null:
		_play_animation(current_animation)

func _play_animation(animation_type:int) -> void:
	var animation_type_string = AnimationNames[animation_type]
	if animation_type_string == "idle":
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("walk")
	if _get_direction_string(move_direction.angle()) == "Right":
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
#	var animation_name = animation_type_string + "_" + _get_direction_string(move_direction.angle())
#	if animation_name != animation_player.current_animation:
#		animation_player.stop(true)
#	#animation_player.play(animation_name)
#	current_animation = animation_type


func _get_direction_string(angle:float) -> String:
	var angle_deg = round(rad2deg(angle))
	if angle_deg > -90.0 and angle_deg < 90.0:
		return "Right"
	return "Left"
	
func set_target_location(target:Vector2) -> void:
	did_arrive = false
	navigation_agent.set_target_location(target)
	#make_sound()

#func _physics_process(delta):
#	if is_in_sight:
#		player = get_node("/root/World/Players/" + Server.player_id).get_children()[0]
#		if player:
#			los.look_at(player.global_position)
#			check_player_in_detection()
#			if player_spotted:
#				move_randomly(delta)
#			elif not is_dead:
#				random_idle_pos = null
#				$AnimatedSprite.play("sleep")


#func move_randomly(delta):
#	if not is_dead:
#		if random_idle_pos == null:
#			$AnimatedSprite.play("walk")
#			in_idle_state = false
#			rng.randomize()
#			random_idle_pos = Vector2(rng.randi_range(-300, 300), rng.randi_range(-300, 300))
#			path = worldNavigation.map_get_path(position, position + random_idle_pos, true)
#		else:
#			navigate(delta)


#func navigate(delta):
#	if path.size() > 0:
#		set_direction(path[0])
#		position = position.move_toward(path[0], delta * SPEED)
#		if position == path[0]:
#			path.pop_front()
#	else:
#		idle_state()


#func set_direction(new_pos):
#	var tempPos = position - new_pos
#	if tempPos.x > 0:
#		$AnimatedSprite.flip_h = true
#	else:
#		$AnimatedSprite.flip_h = false

#
#func idle_state():
#	if not in_idle_state and not is_dead:
#		in_idle_state = true
#		$AnimatedSprite.play("idle")
#		randomize()
#		yield(get_tree().create_timer(rand_range(0, 4.0)), "timeout")
#		random_idle_pos = null
 


func _on_HurtBox_area_entered(area):
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	is_dead = true
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("death")
	yield($AnimatedSprite, "animation_finished")
	$AnimationPlayer.play("death")
	intitiateItemDrop("raw filet", Vector2(0,0))
	yield($AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(6.0), "timeout")
	queue_free()

func intitiateItemDrop(item, pos):
	rng.randomize()
	var itemDrop = ItemDrop.instance()
	itemDrop.initItemDropType(item, 1)
	get_parent().call_deferred("add_child", itemDrop)
	itemDrop.global_position = global_position + pos + Vector2(rng.randi_range(-12, 12), 0)



