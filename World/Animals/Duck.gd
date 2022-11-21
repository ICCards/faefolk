extends KinematicBody2D

onready var ItemDrop = preload("res://InventoryLogic/ItemDrop.tscn")

onready var duck_sprite: AnimatedSprite = $DuckSprite
onready var _timer: Timer = $Timers/Timer
onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D

var enemy_name = "duck"
var is_eating: bool = false
var destroyed: bool = false
var stunned: bool = false
var frozen: bool = false
var poisoned: bool = false
var _velocity := Vector2.ZERO
var health: int = Stats.DUCK_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 500.0
var random_pos
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var tornado_node

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
	duck_sprite.frames = Images.DuckVariations[0]
	orbit_radius = rand_range(30, 70)
	_timer.wait_time = rand_range(2.5, 5.0)
	if Util.chance(50):
		duck_sprite.flip_h = true

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
	if not visible or destroyed or is_eating or stunned:
		return
	if poisoned:
		$PoisonParticles/P1.direction = -_velocity
		$PoisonParticles/P2.direction = -_velocity
		$PoisonParticles/P3.direction = -_velocity
	if tornado_node:
		if is_instance_valid(tornado_node):
			d += delta
			position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
		else: 
			tornado_node = null
	if navigation_agent.is_navigation_finished():
		if not frozen:
			if Util.chance(20):
				is_eating = true
				duck_sprite.play("eat")
				yield(duck_sprite, "animation_finished")
				is_eating = false
			else:
				is_eating = true
				duck_sprite.play("idle")
				$Timers/IdleTimer.start(rand_range(1.0, 4.0))
				#yield(get_tree().create_timer(rand_range(1.0, 4.0)), "timeout")
				#is_eating = false
			return
	duck_sprite.play("walk")
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	navigation_agent.set_velocity(_velocity)
	if _get_direction_string(_velocity) == "Right":
		duck_sprite.flip_h = false
	else:
		duck_sprite.flip_h = true
		
func move(velocity: Vector2) -> void:
	if tornado_node or stunned:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif poisoned:
		_velocity = move_and_slide(velocity*0.9)
	elif running_state:
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
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$AnimationPlayer.play("hit")
		diminish_HOT(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		tornado_node = area
	elif area.special_ability == "fire":
		health -= Stats.FIRE_DEBUFF_DAMAGE


func start_frozen_state(timer_length):
	$Timers/FrozenTimer.start(timer_length)
	duck_sprite.modulate = Color("00c9ff")
	frozen = true

func hit(tool_name, var special_ability = ""):
	if tool_name == "blizzard":
		start_frozen_state(8)
		return
	elif tool_name == "ice projectile":
		start_frozen_state(3.0)
	elif tool_name == "lightning spell debuff":
		start_stunned_state()
	is_eating = false
	start_run_state()
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health <= 0 and not destroyed:
		destroy()
		
func destroy():
	destroyed = true
	duck_sprite.play("death")
	$AnimationPlayer.play("death")
	yield(get_tree().create_timer(0.5), "timeout")
	InstancedScenes.intitiateItemDrop("raw wing", position, 1)
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func diminish_HOT(type):
	start_poison_state()
	var amount_to_diminish
	match type:
		"poison potion I":
			amount_to_diminish = Stats.DUCK_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = Stats.DUCK_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = Stats.DUCK_HEALTH * 0.32
	var increment = int(ceil(amount_to_diminish / 4))
	while int(amount_to_diminish) > 0 and not destroyed:
		if amount_to_diminish < increment:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, position)
			amount_to_diminish = 0
		else:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-increment, position)
			amount_to_diminish -= increment
		if health <= 0 and not destroyed:
			destroy()
		yield(get_tree().create_timer(2.0), "timeout")




func start_run_state():
	running_state = true
	$Timers/RunStateTimer.start()
	_timer.wait_time = 2.0
	_update_pathfinding()


func _on_RunStateTimer_timeout():
	running_state = false
	_timer.wait_time = rand_range(2.5, 5.0)


func _on_FrozenTimer_timeout():
	frozen = false
	if not poisoned and not destroyed:
		duck_sprite.modulate = Color("ffffff")

func start_poison_state():
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	duck_sprite.modulate = Color("009000")
	poisoned = true
	$Timers/PoisonTimer.start()

func _on_PoisonTimer_timeout():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	poisoned = false
	if not frozen and not destroyed:
		duck_sprite.modulate = Color("ffffff")

func start_stunned_state():
	if not destroyed:
		stunned = true
		$Electricity.show()
		duck_sprite.playing = false
		$Timers/StunnedTimer.start()
		
func _on_StunnedTimer_timeout():
	$Electricity.hide()
	duck_sprite.playing = true
	stunned = false

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()


func _on_IdleTimer_timeout():
	is_eating = false
