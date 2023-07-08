extends CharacterBody2D

@onready var hit_box: Area2D = $SpiderHit
@onready var spider_sprite: AnimatedSprite2D = $Spider
@onready var _idle_timer: Timer = $Timers/IdleTimer
@onready var _chase_timer: Timer = $Timers/ChaseTimer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var attacking: bool = false
var knocking_back: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 30.0
var STARTING_HEALTH: int = Stats.SPIDER_HEALTH
var tornado_node = null
var state = IDLE

const KNOCKBACK_SPEED = 25
const ACCELERATION = 90
const KNOCKBACK_AMOUNT = 35
const MAX_RANDOM_CHASE_DIST = 25
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
	_chase_timer.connect("timeout",Callable(self,"_update_pathfinding_chase"))
	_idle_timer.connect("timeout",Callable(self,"_update_pathfinding_idle"))
	navigation_agent.connect("velocity_computed",Callable(self,"move")) 
	_update_pathfinding_idle()

func _update_pathfinding_chase():
	random_pos = Vector2(randf_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST), randf_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST))
	navigation_agent.set_target_position(Server.player_node.global_position+random_pos)
	
func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_position(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed or state == IDLE:
		return
	elif frozen:
		spider_sprite.modulate = Color("00c9ff")
		set_velocity(_velocity*0.75)
		move_and_slide()
	elif poisoned:
		spider_sprite.modulate = Color("009000")
		set_velocity(_velocity*0.9)
		move_and_slide()
	else:
		spider_sprite.modulate = Color("ffffff")
		set_velocity(_velocity)
		move_and_slide()

func _physics_process(delta):
	if destroyed or stunned:
		spider_sprite.stop()
		return
	if knocking_back:
		velocity = velocity.move_toward(knockback * KNOCKBACK_SPEED * 7, ACCELERATION * delta * 8)
		set_velocity(velocity)
		move_and_slide()
		return
	set_sprite_texture()
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
		if not chasing:
			start_chase_state()
	elif Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
		if chasing:
			end_chase_state()
	if navigation_agent.is_navigation_finished() and state == WALK and not chasing:
		velocity = Vector2.ZERO
		state = IDLE
		return
	var target = navigation_agent.get_next_path_position()
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
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/hitEnemy.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	if killed_by_player:
		PlayerData.player_data["collections"]["mobs"]["spider"] += 1
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/monsterdead.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		InstancedScenes.intitiateItemDrop("silk", position, 1)
	destroyed = true
	animation_player.play("destroy")
	await animation_player.animation_finished
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		PlayerData.player_data["skill_experience"]["sword"] += 1
		Stats.decrease_tool_health()
	else:
		PlayerDataHelpers.add_skill_experience(area.tool_name)
	if area.knockback_vector != Vector2.ZERO:
		$KnockbackParticles.emitting = true
		knocking_back = true
		$Timers/KnockbackTimer.start()
		knockback = area.knockback_vector
		velocity = knockback * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.orbit_radius = randf_range(0,20)
		tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(randf_range(-8,8), randf_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	elif area.special_ability == "ice":
		$EnemyFrozenState.start(3)
	elif area.special_ability == "poison":
		$EnemyPoisonState.start("poison arrow")
	if area.tool_name == "arrow" or area.tool_name == "fire projectile":
		area.destroy()
	await get_tree().create_timer(0.25).timeout
	$KnockbackParticles.emitting = false

func start_chase_state():
	chasing = true
	state = CHASE
	navigation_agent.max_speed = 100
	_idle_timer.stop()
	_chase_timer.start()

func end_chase_state():
	chasing = false
	state = IDLE
	navigation_agent.max_speed = 35
	_chase_timer.stop()
	_idle_timer.start()

func _on_KnockbackTimer_timeout():
	knocking_back = false

