extends KinematicBody2D

onready var TornadoProjectile = preload("res://World/Objects/Magic/Wind/TornadoProjectile.tscn")
onready var DashGhost = preload("res://World/Objects/Magic/Wind/DashGhost.tscn")
onready var Whirlwind = preload("res://World/Objects/Magic/Wind/Whirlwind.tscn")
onready var LingeringTornado = preload("res://World/Objects/Magic/Wind/LingeringTornado.tscn")

onready var boss_sprite: Sprite = $Boss
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var random_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false
var health: int = Stats.WIND_BOSS
var STARTING_HEALTH: int = Stats.WIND_BOSS
var state = IDLE

var rng = RandomNumberGenerator.new()

var phase = 1

export var MAX_SPEED = 100
export var ACCELERATION = 200

enum {
	IDLE,
	TRANSITION_TO_FLY,
	FLY,
	TRANSITION_TO_IDLE,
	ATTACK,
	DEATH
}

func _ready():
	randomize()
	rng.randomize()
	animation_player.play("loop")
	$HealthBar/Progress.max_value = Stats.WIND_BOSS
	$HealthBar/Progress.value = Stats.WIND_BOSS


func _on_AttackTimer_timeout():
	attack()

func attack():
	if state != IDLE:
		$ShootDirection.look_at(Server.player_node.position)
		var amt
		if phase == 1:
			amt = 1
		elif phase == 2:
			amt = 3
		else:
			amt = 5
		state = ATTACK
		animation_player.play("attack")
		yield(animation_player, "animation_finished")
		animation_player.play("loop")
		state = FLY
		if phase == 1 or phase == 2:
			for i in range(amt):
				var spell = TornadoProjectile.instance()
				spell.is_hostile_projectile = true
				spell.position =$ShootDirection/Position2D.global_position
				spell.velocity = Server.player_node.position - position
				get_node("../../../").add_child(spell)
				yield(get_tree().create_timer(0.5), "timeout")
		else:
			for i in range(12):
				var spell = LingeringTornado.instance()
				spell.position =$ShootDirection/Position2D.global_position
				spell.is_hostile_projectile = true
				spell.target = Vector2(rand_range(15,45), rand_range(15,45))*32
				get_node("../../").add_child(spell)
				yield(get_tree().create_timer(0.05), "timeout")
	else:
		var directions = ["down", "left", "right", "up"]
		directions.shuffle()
		direction = directions[0]


func set_texture():
	match state:
		IDLE:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Bird Boss/idle/" + direction + "/body.png")
		TRANSITION_TO_FLY:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Bird Boss/transition to fly/" + direction + "/body.png")
		FLY:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Bird Boss/fly/" + direction + "/body.png")
		TRANSITION_TO_IDLE:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Bird Boss/transition to idle/" + direction + "/body.png")
		ATTACK:
			boss_sprite.texture = load("res://Assets/Images/Enemies/Bird Boss/screech/" + direction + "/body.png")


func move(_velocity: Vector2) -> void:
	if stunned or destroyed:
		return
	if frozen:
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		velocity = move_and_slide(_velocity*0.9)
	else:
		velocity = move_and_slide(_velocity)

func _physics_process(delta):
	if destroyed:
		$HealthBar/Progress.hide()
		return
	$HealthBar/Progress.value = health
	set_texture()
	if state == IDLE:
		return
	set_direction_chase_state()
	$ShootDirection.look_at(Server.player_node.position)
	if destroyed:
		return
#	if phase == 3 and not has_node("Whirlwind"):
#		play_whirlwind()
	var direction = (random_pos - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	move(velocity)

func set_direction_chase_state():
	var degrees = int($ShootDirection.rotation_degrees) % 360
	if $ShootDirection.rotation_degrees >= 0:
		if degrees <= 45 or degrees >= 315:
			direction = "right"
		elif degrees <= 135:
			direction = "down"
		elif degrees <= 225:
			direction = "left"
		else:
			direction = "up"
	else:
		if degrees >= -45 or degrees <= -315:
			direction = "right"
		elif degrees >= -135:
			direction = "up"
		elif degrees >= -225:
			direction = "left"
		else:
			direction = "down"

func hit(tool_name):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	destroyed = true
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/killAnimal.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
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
		phase = 2
		$Timers/WhirlwindTimer.start()
		play_whirlwind()
	elif health < 350 and phase != 3:
		#play_dash()
		phase = 3

func play_whirlwind():
	var spell = Whirlwind.instance()
	spell.is_hostile = true
	call_deferred("add_child", spell)

func _on_DetectPlayer_area_entered(area):
	if state == IDLE:
		start_attack_state()
	
func start_attack_state():
	$Timers/AttackTimer.start()
	state = TRANSITION_TO_FLY
	animation_player.play("transition to fly")
	yield(animation_player, "animation_finished")
	state = FLY
	animation_player.play("loop")
	
func _on_ChangePos_timeout():
	random_pos = Vector2(rand_range(10,40), rand_range(10,40))*32

func _on_WhirlwindTimer_timeout():
	play_whirlwind()
