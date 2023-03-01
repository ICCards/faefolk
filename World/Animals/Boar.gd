extends CharacterBody2D

@onready var hit_box: Area2D = $BoarBite
@onready var boar_sprite: Sprite2D = $BoarSprite
@onready var _idle_timer: Timer = $Timers/IdleTimer
@onready var _chase_timer: Timer = $Timers/ChaseTimer
@onready var _retreat_timer: Timer = $Timers/RetreatTimer
@onready var _end_chase_state_timer: Timer = $Timers/EndChaseState
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var player = Server.player_node
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
var MAX_MOVE_DISTANCE: float = 500.0
var health: int = Stats.BOAR_HEALTH
var STARTING_HEALTH: int = Stats.BOAR_HEALTH
var tornado_node = null
var hit_projectiles = []

const KNOCKBACK_SPEED = 40
const ACCELERATION = 150
const KNOCKBACK_AMOUNT = 70

var state = IDLE

var rng := RandomNumberGenerator.new()
var thread := Thread.new()
var destroy_thread := Thread.new()

enum {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	DEATH,
	RETREAT
}

func _ready():
	randomize()
	visible = false
	animation_player.call_deferred("play","loop")
	_idle_timer.set_deferred("wait", randf_range(4.0,8.0)) 
	_chase_timer.connect("timeout",Callable(self,"_update_pathfinding_chase"))
	_idle_timer.connect("timeout",Callable(self,"_update_pathfinding_idle"))
	_retreat_timer.connect("timeout",Callable(self,"_update_pathfinding_retreat"))
	navigation_agent.connect("velocity_computed",Callable(self,"move_deferred")) 
	navigation_agent.call_deferred("set_navigation", get_node("/root/World/Node2D"))

func _update_pathfinding_idle():
	if not thread.is_alive() and visible and not destroyed:
		thread.start(Callable(self,"_get_path").bind(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE)))
		state = WALK

func _update_pathfinding_chase():
	if not thread.is_alive() and visible and not destroyed:
		thread.start(Callable(self,"_get_path").bind(player.position))

func _get_path(pos):
	call_deferred("calculate_path", pos)
	
func calculate_path(pos):
	if not destroyed:
		await get_tree().idle_frame
		navigation_agent.call_deferred("set_target_location",pos)
		await get_tree().idle_frame
	thread.wait_to_finish()

func _update_pathfinding_retreat():
	var target = Vector2(200,200)
	var diff = player.position - self.position
	if diff.x > 0:
		target.x = -200
	if diff.y > 0:
		target.y = -200
	if not thread.is_alive() and visible and not destroyed:
		thread.start(Callable(self,"_get_path").bind(self.position+target))
	
func set_sprite_texture():
	if not attacking or destroyed:
		match state:
			IDLE:
				boar_sprite.texture = load("res://Assets/Images/Animals/Boar/idle/" +  direction + "/body.png")
			WALK:
				boar_sprite.texture = load("res://Assets/Images/Animals/Boar/walk/" +  direction + "/body.png")
			_:
				boar_sprite.texture = load("res://Assets/Images/Animals/Boar/run/" +  direction + "/body.png")

func move_deferred(_velocity: Vector2) -> void:
	call_deferred("move", _velocity)

func move(_velocity: Vector2) -> void:
	if not visible or tornado_node or stunned or destroyed or attacking or state == IDLE:
		return
	if frozen:
		set_velocity(_velocity*0.75)
		move_and_slide()
		velocity = velocity
		boar_sprite.modulate = Color("00c9ff")
	elif poisoned:
		set_velocity(_velocity*0.9)
		move_and_slide()
		velocity = velocity
		boar_sprite.modulate = Color("009000")
	else:
		set_velocity(_velocity)
		move_and_slide()
		velocity = velocity
		boar_sprite.modulate = Color("ffffff")


func _physics_process(delta):
	if not visible or destroyed or stunned: 
		return
	$LineOfSight.look_at(player.global_position)
	if knocking_back:
		velocity = velocity.move_toward(knockback * KNOCKBACK_SPEED * 7, ACCELERATION * delta * 8)
		set_velocity(velocity)
		move_and_slide()
		velocity = velocity
		return
	set_sprite_texture()
	if navigation_agent.is_navigation_finished() and state == WALK:
		state = IDLE
		velocity = Vector2.ZERO
		return
	if (player.state == 5 or player.get_node("Magic").invisibility_active) and chasing:
		end_chase_state()
	elif not (player.state == 5 or player.get_node("Magic").invisibility_active) and $DetectPlayer.get_overlapping_areas().size() >= 1 and not chasing and state != RETREAT:
		start_chase_state()
	if chasing and (position+Vector2(0,-9)).distance_to(player.position) < 70:
		state = ATTACK
		attack()
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	
func attack():
	if not attacking:
		call_deferred("play_attack_sound_effect")
		attacking = true
		hit_box.call_deferred("look_at", player.position)
		boar_sprite.set_deferred("texture", load("res://Assets/Images/Animals/Boar/attack/" +  direction + "/body.png"))
		animation_player.call_deferred("play", "attack")
		await get_tree().create_timer(0.4).timeout
		if not destroyed and Util.isValidEnemyAttack($LineOfSight):
			$BoarBite/CollisionShape2D.set_deferred("disabled", false)
		await animation_player.animation_finished
		if not destroyed:
			animation_player.call_deferred("play", "loop")
			attacking = false
			if state != RETREAT:
				state = CHASE

func hit(tool_name):
	play_hurt_sound_effect()
	if state == IDLE or state == WALK:
		call_deferred("start_chase_state")
	if tool_name == "blizzard":
		boar_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 8)
		return
	elif tool_name == "ice projectile":
		boar_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.call_deferred("start")
	_end_chase_state_timer.call_deferred("start", 20)
	$HurtBox/AnimationPlayer.call_deferred("play", "hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health < STARTING_HEALTH*.3:
		call_deferred("start_retreat_state")
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	_retreat_timer.call_deferred("stop")
	_chase_timer.call_deferred("stop")
	_idle_timer.call_deferred("stop")
	set_physics_process(false)
	if killed_by_player:
		MapData.remove_animal(name)
		PlayerData.player_data["collections"]["mobs"]["boar"] += 1
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/death.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
		sound_effects.call_deferred("play")
	destroyed = true
	$BoarBite/CollisionShape2D.set_deferred("disabled", true)
	boar_sprite.set_deferred("texture", load("res://Assets/Images/Animals/Boar/death/" +  direction + "/body.png"))
	animation_player.call_deferred("play", "death")
	await get_tree().create_timer(0.5).timeout
	InstancedScenes.intitiateItemDrop("raw filet", position, rng.randi_range(0,2))
	InstancedScenes.intitiateItemDrop("cloth", position, rng.randi_range(0,2))
	await animation_player.animation_finished
	queue_free()

func _on_HurtBox_area_entered(area):
	if not hit_projectiles.has(area.id):
		if area.id != "":
			hit_projectiles.append(area.id)
		if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
			boar_sprite.set_deferred("modulate", Color("009000"))
			$HurtBox/AnimationPlayer.call_deferred("play","hit")
			$EnemyPoisonState.call_deferred("start", area.tool_name)
			return
		if area.name == "SwordSwing":
			PlayerData.player_data["skill_experience"]["sword"] += 1
			Stats.decrease_tool_health()
		else:
			PlayerDataHelpers.add_skill_experience(area.tool_name)
		if area.knockback_vector != Vector2.ZERO:
			$KnockbackParticles.set_deferred("emitting", true)
			knocking_back = true
			$Timers/KnockbackTimer.call_deferred("start")
			knockback = area.knockback_vector
			velocity = knockback * 200
		if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
			call_deferred("hit", area.tool_name)
		if area.tool_name == "lingering tornado":
			$EnemyTornadoState.set_deferred("orbit_radius", randf_range(0,20))
			tornado_node = area
		if area.special_ability == "fire":
			var randomPos = Vector2(randf_range(-8,8), randf_range(-8,8))
			InstancedScenes.initiateExplosionParticles(position+randomPos)
			InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
			health -= Stats.FIRE_DEBUFF_DAMAGE
		elif area.special_ability == "ice":
			boar_sprite.set_deferred("modulate", Color("00c9ff"))
			$EnemyFrozenState.call_deferred("start", 3)
		elif area.special_ability == "poison":
			boar_sprite.set_deferred("modulate", Color("009000"))
			$EnemyPoisonState.call_deferred("start", "poison arrow")
		await get_tree().create_timer(0.25).timeout
		$KnockbackParticles.set_deferred("emitting", false)

func start_retreat_state():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/retreat.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	state = RETREAT
	_idle_timer.call_deferred("stop")
	_chase_timer.call_deferred("stop")
	_retreat_timer.call_deferred("start")
	call_deferred("start_sound_effects")
	chasing = false
	
func start_chase_state():
	chasing = true
	state = CHASE
	navigation_agent.set_deferred("max_speed", 170)
	_idle_timer.call_deferred("stop")
	_chase_timer.call_deferred("start")
	_end_chase_state_timer.call_deferred("start", 20)
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/engage.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	await sound_effects.finished
	if not destroyed:
		call_deferred("start_sound_effects")

func end_chase_state():
	chasing = false
	navigation_agent.set_deferred("max_speed", 100)
	call_deferred("stop_sound_effects")
	_chase_timer.call_deferred("stop") 
	_idle_timer.call_deferred("start")
	call_deferred("_update_pathfinding_idle")
	state = WALK

func _on_KnockbackTimer_timeout():
	knocking_back = false

func _on_EndChaseState_timeout():
	if $DetectPlayer.get_overlapping_areas().size() == 0:
		if not $DetectPlayer/CollisionShape2D.disabled:
			_end_chase_state_timer.call_deferred("start", 5)
			$DetectPlayer/CollisionShape2D.set_deferred("disabled", true)
			call_deferred("end_chase_state")
		else:
			$DetectPlayer/CollisionShape2D.set_deferred("disabled", false)
	else:
		_end_chase_state_timer.call_deferred("start", 5)


func play_hurt_sound_effect():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/hurt"+ str(rng.randi_range(1,2)) +".mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	await sound_effects.finished
	playing_sound_effect = false
	call_deferred("start_sound_effects")

func play_attack_sound_effect():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/attack.mp3"))
	sound_effects.set_deferred( "volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	await sound_effects.finished
	playing_sound_effect = false
	call_deferred("start_sound_effects")

func start_sound_effects():
	if not playing_sound_effect and not destroyed:
		playing_sound_effect = true
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/boar/gallop2.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -12))
		sound_effects.call_deferred("play")

func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.call_deferred("stop")

func _on_VisibilityNotifier2D_screen_entered():
	if chasing:
		call_deferred("start_sound_effects")
	set_deferred("visible", true)

func _on_VisibilityNotifier2D_screen_exited():
	if MapData.world["animal"].has(name):
		MapData.world["animal"][name]["l"] = position/32
		if playing_sound_effect:
			call_deferred("stop_sound_effects")
		set_deferred("visible", false)


