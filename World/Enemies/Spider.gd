extends KinematicBody2D

onready var hit_box: Area2D = $SpiderHit
onready var spider_sprite: AnimatedSprite = $Spider
onready var _idle_timer: Timer = $Timers/IdleTimer
onready var _chase_timer: Timer = $Timers/ChaseTimer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var knocking_back: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 60.0
var changed_direction_delay: bool = false
var STARTING_HEALTH: int = Stats.SPIDER_HEALTH
var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius = 0
var state = IDLE
const KNOCKBACK_SPEED = 100
const ACCELERATION = 180
const KNOCKBACK_AMOUNT = 70
const MAX_RANDOM_CHASE_DIST = 50
var health

enum {
	IDLE,
	WALK,
	CHASE,
}

var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	health = STARTING_HEALTH
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	navigation_agent.connect("velocity_computed", self, "move") 
	navigation_agent.set_navigation(get_node("../../").nav_node)

func _update_pathfinding_chase():
	random_pos = Vector2(rand_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST), rand_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST))
	navigation_agent.set_target_location(Server.player_node.global_position+random_pos)
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())

func get_random_pos():
	random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position
	
func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	elif frozen:
		spider_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		spider_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		spider_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)

func _physics_process(delta):
	if Server.player_node:
		if destroyed or stunned:
			spider_sprite.playing = false
			return
		spider_sprite.playing = true
		if knocking_back:
			velocity = velocity.move_toward(knockback * KNOCKBACK_SPEED * 7, ACCELERATION * delta * 8)
			velocity = move_and_slide(velocity)
			return
		if tornado_node:
			orbit_radius += 1.0
			if is_instance_valid(tornado_node):
				d += delta
				position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
			else: 
				tornado_node = null
		set_direction()
		set_sprite_texture()
		if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
			if state != CHASE:
				start_chase_state()
#		if (Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active) and state == CHASE:
#			end_chase_state()
#		elif $DetectPlayer.get_overlapping_areas().size() > 0 and state != CHASE:
#			start_chase_state()
		if navigation_agent.is_navigation_finished():
			state = IDLE
			return
		var target = navigation_agent.get_next_location()
		var move_direction = position.direction_to(target)
		var desired_velocity = move_direction * navigation_agent.max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		navigation_agent.set_velocity(velocity)
	
	
func set_sprite_texture():
	if state == IDLE:
		if direction == "left":
			$Spider.flip_h = true
			$Spider.play("idle right")
		else:
			$Spider.flip_h = false
			$Spider.play("idle " + direction)
	else:
		if direction == "left":
			$Spider.flip_h = true
			$Spider.play("walk right")
		else:
			$Spider.flip_h = false
			$Spider.play("walk " + direction)
	
func set_direction():
	if not changed_direction_delay:
		if abs(velocity.x) >= abs(velocity.y):
			if velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_delay()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_delay()
		else:
			if velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_delay()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_delay()


func hit(tool_name):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	if state == IDLE or state == WALK:
		start_chase_state()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/hitEnemy.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	InstancedScenes.intitiateItemDrop("rope", position, 1)
	destroyed = true
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != Vector2.ZERO:
		$KnockbackParticles.emitting = true
		knocking_back = true
		$Timers/KnockbackTimer.start()
		knockback = area.knockback_vector
		velocity = knockback * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		orbit_radius = 0
		tornado_node = area
	yield(get_tree().create_timer(0.25), "timeout")
	$KnockbackParticles.emitting = false

func start_chase_state():
	print("START CHASE")
	state = CHASE
	navigation_agent.max_speed = 200
	_idle_timer.stop()
	_chase_timer.start()

func end_chase_state():
	print("END CHASE")
	state = IDLE
	navigation_agent.max_speed = 100
	_chase_timer.stop()
	_idle_timer.start()


func set_change_direction_delay():
	changed_direction_delay = true
	yield(get_tree().create_timer(0.25), "timeout")
	changed_direction_delay = false

func _on_KnockbackTimer_timeout():
	knocking_back = false

