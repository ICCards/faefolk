extends KinematicBody2D

onready var FireProjectile = preload("res://World/Objects/Magic/Fire/FireProjectile.tscn")
onready var ArrowProjectile = preload("res://World/Objects/Projectiles/ArrowProjectile.tscn")

onready var skeleton_sprite: AnimatedSprite = $SkeletonSprite
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
var chasing: bool = false
var knocking_back: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 60.0
var changed_direction_delay: bool = false
var cancel_attack: bool = false
var health: int = Stats.SKELETON_HEALTH
var STARTING_HEALTH: int = Stats.SKELETON_HEALTH
var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var state = IDLE
const KNOCKBACK_SPEED = 100
const ACCELERATION = 180
const FRICTION = 80
const KNOCKBACK_AMOUNT = 70

enum {
	IDLE,
	WALK,
	CHASE,
}
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	_idle_timer.wait_time = rand_range(4.0,6.0)
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	navigation_agent.connect("velocity_computed", self, "move") 
	navigation_agent.set_navigation(get_node("../../").nav_node)

func _update_pathfinding_chase():
	navigation_agent.set_target_location(get_random_player_pos(Server.player_node.global_position))
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())

func get_random_player_pos(_player_pos):
	var random1 = rand_range(75, 100)
	var random2 = rand_range(75, 100)
	if Util.chance(50):
		random1 *= -1
	if Util.chance(50):
		random2 *= -1
	random_pos = Vector2(random1, random2)
	if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(_player_pos + random_pos)) == -1:
		return _player_pos + random_pos
	elif Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(_player_pos - random_pos)) == -1:
		return _player_pos - random_pos
	else:
		return _player_pos

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
		skeleton_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		skeleton_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		skeleton_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)

func _physics_process(delta):
	if Server.player_node:
		if destroyed or stunned:
			return
		skeleton_sprite.playing = true
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
		set_sprite_texture()
		if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
			if state != CHASE:
				start_chase_state()
		elif Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
			end_chase_state()
		if navigation_agent.is_navigation_finished() and state != CHASE:
			state = IDLE
			return
		var target = navigation_agent.get_next_location()
		var move_direction = position.direction_to(target)
		var desired_velocity = move_direction * navigation_agent.max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		navigation_agent.set_velocity(velocity)
	
	
func set_sprite_texture():
	$ShootDirection.look_at(Server.player_node.position)
	if state == IDLE:
		skeleton_sprite.play("idle")
	elif state == WALK:
		skeleton_sprite.flip_h = velocity.x <= 0
		skeleton_sprite.play("walk")
	elif not destroyed:
		attack()
		
func attack():
	var degrees = int($ShootDirection.rotation_degrees) % 360
	if $ShootDirection.rotation_degrees >= 0:
		if degrees <= 90 or degrees >= 270:
			direction = "right"
		else:
			direction = "left"
	else:
		if degrees >= -90 or degrees <= -270:
			direction = "right"
		else:
			direction = "left"
	skeleton_sprite.flip_h = direction == "left"
	if not attacking:
		attacking = true
		skeleton_sprite.play("attack")
		yield(get_tree().create_timer(2.0), "timeout")
		if not destroyed and not cancel_attack:
			shoot_projectile()
			yield(skeleton_sprite, "animation_finished")
		attacking = false
		cancel_attack = false
		
		
func shoot_projectile():
	var spell = ArrowProjectile.instance()
	spell.is_hostile = true
	spell.position = $ShootDirection/Position2D.global_position
	spell.velocity = Server.player_node.position - spell.position
	get_node("../").add_child(spell)
	

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
	cancel_attack = true
	skeleton_sprite.play("hit")
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	InstancedScenes.intitiateItemDrop("arrow", position, 1)
	animation_player.play("death")
	destroyed = true
	yield(skeleton_sprite, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/hitEnemy.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		if state == IDLE or state == WALK:
			start_chase_state()
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != Vector2.ZERO:
		knocking_back = true
		$Timers/KnockbackTimer.start()
		knockback = area.knockback_vector
		velocity = knockback * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		orbit_radius = 0
		tornado_node = area

func start_chase_state():
	navigation_agent.max_speed = 125
	_idle_timer.stop()
	_chase_timer.start()
	navigation_agent.set_target_location(get_random_player_pos(Server.player_node.global_position))
	chasing = true
	state = CHASE 

func end_chase_state():
	navigation_agent.max_speed = 75
	_chase_timer.stop()
	_idle_timer.start()
	chasing = false
	state = IDLE


func _on_KnockbackTimer_timeout():
	knocking_back = false

