extends CharacterBody2D

@onready var FireProjectile = load("res://World/Objects/Magic/Fire/FireProjectile.tscn")
@onready var FlameThrower = load("res://World/Objects/Magic/Fire/Flamethrower.tscn")

@onready var hit_box: Node2D = $ShootDirection
@onready var boss_sprite: Sprite2D = $Boss
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var _idle_timer: Timer = $Timers/IdleTimer
@onready var _chase_timer: Timer = $Timers/ChaseTimer


var direction: String = "down"
var changing_phase: bool = false
var destroyed: bool = false
var chasing: bool = false
var poisoned: bool = false
var frozen: bool = false
var stunned: bool = false
var attacking: bool = false
var random_pos := Vector2.ZERO
#var velocity := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 200.0
var changed_direction_delay: bool = false
var health: int = Stats.WIND_BOSS
var STARTING_HEALTH: int = Stats.WIND_BOSS
var state = IDLE
const MAX_RANDOM_CHASE_DIST = 100
var rng = RandomNumberGenerator.new()

var phase = 1

var MAX_SPEED = 100
var ACCELERATION = 200

enum {
	IDLE,
	WALK,
	ATTACK,
	DEATH
}


func _ready():
	randomize()
	rng.randomize()
	animation_player.play("loop")
	$HealthBar/Progress.max_value = Stats.WIND_BOSS
	$HealthBar/Progress.value = Stats.WIND_BOSS
	_chase_timer.connect("timeout",Callable(self,"_update_pathfinding_chase"))
	_idle_timer.connect("timeout",Callable(self,"_update_pathfinding_idle"))
	navigation_agent.connect("velocity_computed",Callable(self,"move")) 
	navigation_agent.set_navigation(get_node("../../").nav_node)
	_update_pathfinding_idle()
	
func _update_pathfinding_chase():
	if not attacking:
		random_pos = Vector2(randf_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST), randf_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST))
		navigation_agent.set_target_location(Server.player_node.global_position+random_pos)
	
func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_location(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func _on_AttackTimer_timeout():
	attack()

func attack():
	if chasing and not destroyed and not changing_phase:
		$ShootDirection.look_at(Server.player_node.position)
		state = ATTACK
		animation_player.play("attack")
		await animation_player.animation_finished
		if destroyed:
			return
		if phase == 1:
			var spell = FireProjectile.instantiate()
			spell.is_hostile_projectile = true
			spell.position =$ShootDirection/Marker2D.global_position
			spell.velocity = Server.player_node.position - position
			get_node("../../../").call_deferred("add_child", spell)
			await get_tree().create_timer(0.5).timeout
		elif phase == 2:
			for i in range(3):
				var spell = FireProjectile.instantiate()
				spell.debuff = true
				spell.position =$ShootDirection/Marker2D.global_position
				spell.is_hostile_projectile = true
				spell.velocity = Server.player_node.position - position
				get_node("../../").call_deferred("add_child",spell)
				await get_tree().create_timer(0.5).timeout
		else:
			var spell = FlameThrower.instantiate()
			spell.is_hostile = true
			$ShootDirection.call_deferred("add_child",spell)
			spell.position = $ShootDirection/Marker2D.position
			await get_tree().create_timer(0.5).timeout
			for i in range(3):
				var spell2 = FireProjectile.instantiate()
				spell2.debuff = true
				spell2.position =$ShootDirection/Marker2D.global_position
				spell2.is_hostile_projectile = true
				spell2.velocity = Server.player_node.position - position
				get_node("../../").call_deferred("add_child",spell2)
				await get_tree().create_timer(0.5).timeout
			await get_tree().create_timer(2.0).timeout
		if destroyed:
			return
		animation_player.play("loop")
		state = WALK
		$Timers/AttackTimer.start()

func set_texture():
	match state:
		IDLE:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Dragon Boss/idle/" + direction + "/body.png")
		WALK:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Dragon Boss/walk/" + direction + "/body.png")
		ATTACK:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Dragon Boss/fireball/" + direction + "/body.png")


func move(_velocity: Vector2) -> void:
	if destroyed or changing_phase or state == IDLE or state == ATTACK:
		return
	elif frozen:
		boss_sprite.modulate = Color("00c9ff")
		set_velocity(_velocity*0.75)
		move_and_slide()
		velocity = velocity
	elif poisoned:
		boss_sprite.modulate = Color("009000")
		set_velocity(_velocity*0.9)
		move_and_slide()
		velocity = velocity
	else:
		boss_sprite.modulate = Color("ffffff")
		set_velocity(_velocity)
		move_and_slide()
		velocity = velocity

func _physics_process(delta):
	if destroyed:
		return
	$HealthBar/Progress.value = health
	set_texture()
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
		if not chasing:
			start_attack_state()
	elif Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
		if chasing:
			end_attack_state()
	if navigation_agent.is_navigation_finished() and state == WALK:
		velocity = Vector2.ZERO
		state = IDLE
		return
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)


func hit(tool_name):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
		pass
	elif tool_name == "lightning spell debuff":
		#$EnemyStunnedState.start()
		pass
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	if killed_by_player:
		PlayerData.player_data["skill_experience"]["fire"] += 1
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/killAnimal.wav")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		InstancedScenes.intitiateItemDrop("fire staff", position, 1)
	destroyed = true
	animation_player.play("death")
	$Timers/AttackTimer.stop()
	await animation_player.animation_finished
	queue_free()

func _on_HurtBox_area_entered(area):
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/hitEnemy.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	if state == IDLE:
		start_attack_state()
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.special_ability == "fire":
		InstancedScenes.initiateExplosionParticles(position)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	set_phase()

func set_phase():
	if health > 650:
		return
	elif health > 350 and phase != 2:
		play_change_phase()
		await get_tree().create_timer(1.0).timeout
		phase = 2
		MAX_SPEED = 125
	elif health < 350 and phase != 3:
		play_change_phase()
		await get_tree().create_timer(1.0).timeout
		MAX_SPEED = 180
		phase = 3

func play_change_phase():
	animation_player.stop(false)
	changing_phase = true
	$UpgradePhase.show()
	$UpgradePhase.frame = 0
	$UpgradePhase.playing = true
	await $UpgradePhase.animation_finished
	animation_player.play()
	changing_phase = false
	$UpgradePhase.hide()

func start_attack_state():
	navigation_agent.max_speed = 150
	$Timers/AttackTimer.start()
	state = WALK
	chasing = true
	_idle_timer.stop()
	_chase_timer.start()
	
func end_attack_state():
	navigation_agent.max_speed = 75
	$Timers/AttackTimer.stop()
	chasing = false
	state = IDLE
	_idle_timer.start()
	_chase_timer.stop()

	
