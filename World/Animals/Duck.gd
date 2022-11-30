extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
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
var velocity := Vector2.ZERO
var health: int = Stats.DUCK_HEALTH
var STARTING_HEALTH: int = Stats.DUCK_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 500.0
var tornado_node

func _ready():
	hide()
	set_random_attributes()
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func set_random_attributes():
	randomize()
	Images.DuckVariations.shuffle()
	duck_sprite.frames = Images.DuckVariations[0]
	_timer.wait_time = rand_range(2.5, 5.0)
	if Util.chance(50):
		duck_sprite.flip_h = true

func _physics_process(delta):
	if not visible or destroyed or is_eating or stunned:
		if stunned:
			duck_sprite.playing = false
		return
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
			return
	duck_sprite.play("walk")
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	if _get_direction_string(velocity) == "Right":
		duck_sprite.flip_h = false
	else:
		duck_sprite.flip_h = true


func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	if frozen:
		duck_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		duck_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		duck_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)


func _get_direction_string(velocitiy) -> String:
	if velocitiy.x > 0:
		return "Right"
	return "Left"


func _update_pathfinding() -> void:
	navigation_agent.set_target_location(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.orbit_radius = rand_range(0,20)
		tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(rand_range(-8,8), rand_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE


func start_frozen_state(timer_length):
	$Timers/FrozenTimer.start(timer_length)
	duck_sprite.modulate = Color("00c9ff")
	frozen = true

func hit(tool_name, var special_ability = ""):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
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

func start_run_state():
	running_state = true
	$Timers/RunStateTimer.start()
	_timer.wait_time = 2.0
	_update_pathfinding()


func _on_RunStateTimer_timeout():
	running_state = false
	_timer.wait_time = rand_range(2.5, 5.0)

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()

func _on_IdleTimer_timeout():
	is_eating = false
