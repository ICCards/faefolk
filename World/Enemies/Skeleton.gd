extends CharacterBody2D

@onready var ArrowProjectile = load("res://World/Objects/Projectiles/ArrowProjectile.tscn")

@onready var hit_box: Node2D = $ShootDirection
@onready var skeleton_sprite: Sprite2D = $SkeletonSprite
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
var knocking_back: bool = false
var aiming: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 30.0
var cancel_attack: bool = false
var health: int = Stats.SKELETON_HEALTH
var STARTING_HEALTH: int = Stats.SKELETON_HEALTH

var state = IDLE
const KNOCKBACK_SPEED = 30
const ACCELERATION = 45
const FRICTION = 20
const KNOCKBACK_AMOUNT = 20

enum {
	IDLE,
	WALK,
	AIM_IDLE,
	AIM_WALK,
	SHOOT,
	RELEASE
}

var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	animation_player.play("loop")
	_idle_timer.wait_time = randf_range(4.0,6.0)
	_chase_timer.connect("timeout",Callable(self,"_update_pathfinding_chase"))
	_idle_timer.connect("timeout",Callable(self,"_update_pathfinding_idle"))
	navigation_agent.connect("velocity_computed",Callable(self,"move")) 

func _update_pathfinding_chase():
	if not aiming:
		state = WALK
	navigation_agent.set_target_position(get_random_player_pos(Server.player_node.global_position))
	
func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_position(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func get_random_player_pos(_player_pos):
	var random1 = randf_range(30, 40)
	var random2 = randf_range(30, 40)
	if Util.chance(50):
		random1 *= -1
	if Util.chance(50):
		random2 *= -1
	random_pos = Vector2(random1, random2)
	if Tiles.cave_wall_tiles.get_cell_atlas_coords(0,Tiles.cave_wall_tiles.local_to_map(_player_pos + random_pos)) == Vector2i(-1,-1):
		return _player_pos + random_pos
	elif Tiles.cave_wall_tiles.get_cell_atlas_coords(0,Tiles.cave_wall_tiles.local_to_map(_player_pos - random_pos)) == Vector2i(-1,-1):
		return _player_pos - random_pos
	else:
		return _player_pos


func move(_velocity: Vector2) -> void:
	if $EnemyTornadoState.tornado_node or stunned or destroyed or attacking:
		return
	elif frozen:
		skeleton_sprite.modulate = Color("00c9ff")
		set_velocity(_velocity*0.75)
		move_and_slide()
	elif poisoned:
		skeleton_sprite.modulate = Color("009000")
		set_velocity(_velocity*0.9)
		move_and_slide()
	else:
		skeleton_sprite.modulate = Color("ffffff")
		set_velocity(_velocity)
		move_and_slide()

func _physics_process(delta):
	if destroyed or stunned:
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
	if navigation_agent.is_navigation_finished() and not aiming:
		velocity = Vector2.ZERO
		state = IDLE
		return
	elif navigation_agent.is_navigation_finished() and state == AIM_WALK:
		velocity = Vector2.ZERO
		state = AIM_IDLE
		return
	var target = navigation_agent.get_next_path_position()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)


func set_sprite_texture():
	match state:
		IDLE:
			skeleton_sprite.texture = load("res://Assets/Images/Enemies/skeleton/IDLE/"+ direction +"/body.png")
		WALK:
			skeleton_sprite.texture = load("res://Assets/Images/Enemies/skeleton/WALK/"+ direction +"/body.png")
		AIM_IDLE:
			skeleton_sprite.texture = load("res://Assets/Images/Enemies/skeleton/DRAW/"+ direction +"/body.png")
		AIM_WALK:
			skeleton_sprite.texture = load("res://Assets/Images/Enemies/skeleton/WALK AIM/"+ direction +"/body.png")
		RELEASE:
			skeleton_sprite.texture = load("res://Assets/Images/Enemies/skeleton/RELEASE/"+ direction +"/body.png")


func attack():
	if not aiming:
		cancel_attack = false
		aiming = true
		if velocity == Vector2.ZERO:
			state = AIM_IDLE
		else:
			state = AIM_WALK
		animation_player.play("draw bow")
		await animation_player.animation_finished
		if not attacking:
			state = RELEASE
			attacking = true
			animation_player.play("release bow")
			if not destroyed:
				await get_tree().create_timer(0.3).timeout 
				var current_player_pos = Server.player_node.position
				await get_tree().create_timer(0.3).timeout
				if not cancel_attack:
					shoot_projectile(current_player_pos)
				await animation_player.animation_finished
				animation_player.play("loop")
				attacking = false
				aiming = false
				state = WALK


func shoot_projectile(player_pos):
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Bow and arrow/release.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	sound_effects.play()
	var spell = ArrowProjectile.instantiate()
	spell.is_hostile = true
	spell.position = $ShootDirection/Marker2D.global_position
	spell.velocity = (player_pos - spell.position).normalized()
	get_node("../../").add_child(spell)
	

func hit(tool_name):
	if tool_name == "blizzard":
		skeleton_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		skeleton_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	if state == IDLE or state == WALK:
		start_chase_state()
	if state == AIM_IDLE or state == AIM_WALK or state == RELEASE:
		state = WALK
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/skeleton/skeletonHit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	cancel_attack = true
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	if killed_by_player:
		PlayerData.player_data["collections"]["mobs"]["skeleton"] += 1
	var random = rng.randi_range(1,3)
	for i in range(random):
		InstancedScenes.intitiateItemDrop("bone", position, 1)
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/skeleton/skeletonDie.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	if Util.chance(5):
		InstancedScenes.initiateInventoryItemDrop(["bow", 1, Stats.return_max_tool_health("bow")], position)
	elif Util.chance(50):
		InstancedScenes.intitiateItemDrop("arrow", position, 1)
	animation_player.play("death")
	$DeathAnimation.play("play")
	destroyed = true
	await animation_player.animation_finished
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		if state == IDLE or state == WALK:
			start_chase_state()
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
		$EnemyTornadoState.tornado_node = area
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
	$Timers/AttackTimer.start()
	navigation_agent.max_speed = 60
	_idle_timer.stop()
	_chase_timer.start()
	navigation_agent.set_target_position(get_random_player_pos(Server.player_node.global_position))
	chasing = true
	state = WALK

func end_chase_state():
	$Timers/AttackTimer.stop()
	navigation_agent.max_speed = 25
	_chase_timer.stop()
	_idle_timer.start()
	chasing = false


func _on_KnockbackTimer_timeout():
	knocking_back = false


func _on_AttackTimer_timeout():
	attack()
