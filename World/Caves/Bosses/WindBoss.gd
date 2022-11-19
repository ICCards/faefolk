extends KinematicBody2D

onready var TornadoProjectile = preload("res://World/Objects/Magic/Wind/TornadoProjectile.tscn")
onready var DashGhost = preload("res://World/Objects/Magic/Wind/DashGhost.tscn")
onready var Whirlwind = preload("res://World/Objects/Magic/Wind/Whirlwind.tscn")

onready var _chase_timer: Timer = $Timers/ChaseTimer
onready var boss_sprite: AnimatedSprite = $BossSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var dashing: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false
var health: int = Stats.WIND_BOSS
var state = IDLE

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

var phase = 1

var JUMP_AMOUNT = 100
var KNOCKBACK_AMOUNT = 180
export var MAX_SPEED = 80
export var ACCELERATION = 200
export var FRICTION = 80

var cancel_jump = false

enum {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	DEATH
}

func _ready():
	randomize()
	rng.randomize()
	yield(get_tree().create_timer(1.0) ,"timeout")
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	navigation_agent.connect("velocity_computed", self, "move") 
	navigation_agent.set_navigation(get_node("../../").nav_node)
	$HealthBar/Progress.max_value = Stats.WIND_BOSS
	$HealthBar/Progress.value = Stats.WIND_BOSS


func _update_pathfinding_chase(): 
	navigation_agent.set_target_location(get_random_player_pos(Server.player_node.global_position))

func get_random_player_pos(_player_pos):
	var random1 = rand_range(300, 400)
	var random2 = rand_range(300, 400)
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


func play_dash():
	navigation_agent.set_target_location(get_random_player_pos(Server.player_node.global_position))
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Wind/dash.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	sound_effects.play()
	$Dash/DustParticles.emitting = true
	#$Dash/DustBSurst.rotation = (get_parent().input_vector*-1).angle()
	$Dash/DustBurst.restart()
	$Dash/DustBurst.emitting = true
	dashing = true
	$Dash/GhostTimer.start()
	navigation_agent.max_speed = 100000
	yield(get_tree().create_timer(0.5), "timeout")
	navigation_agent.max_speed = 150
	$Dash/DustParticles.emitting = false
	$Dash/DustBurst.emitting = false
	dashing = false
	$Dash/GhostTimer.stop()
	
func _on_GhostTimer_timeout():
	var sprite = $Sprite
	var ghost: Sprite = DashGhost.instance()
	get_node("../../").add_child(ghost)
	ghost.global_position = global_position + Vector2(0,-32)
	ghost.texture = sprite.texture
	ghost.hframes = 20
	ghost.vframes = 3
	ghost.frame = 30

func _on_AttackTimer_timeout():
	attack()

func attack():
	$ShootDirection.look_at(Server.player_node.position)
	var amt
	if phase == 1:
		amt = 1
	elif phase == 2:
		amt = 3
	else:
		play_whirlwind()
		return
	for i in range(amt):
		var spell = TornadoProjectile.instance()
		spell.is_hostile_projectile = true
		spell.particles_transform = $ShootDirection.transform
		spell.position =$ShootDirection/Position2D.global_position
		spell.velocity = Server.player_node.position - spell.position
		get_node("../../../").add_child(spell)
		yield(get_tree().create_timer(0.5), "timeout")


func move(velocity: Vector2) -> void:
	if stunned or destroyed:
		return
	if dashing:
		_velocity = move_and_slide(velocity*10)
	elif frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif poisoned:
		_velocity = move_and_slide(velocity*0.9)
	else:
		_velocity = move_and_slide(velocity)

func _physics_process(delta):
	if Server.player_node:
		#$ShootDirection.look_at(Server.player_node.position)
	#	$ShootDirection.look_at(Vector2(rand_range(0,50*32), rand_range(0,50*32)))
		if destroyed or not visible:
			return
	#	if phase == 3 and not has_node("Whirlwind"):
	#		play_whirlwind()
		var direction = (Server.player_node.global_position+random_pos - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		move(velocity)

func hit(tool_name):
	if tool_name == "blizzard":
		start_frozen_state(8)
		return
	elif tool_name == "ice projectile":
		start_frozen_state(3)
	elif tool_name == "lightning spell debuff":
		start_stunned_state()
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
		diminish_HOT(area.tool_name)
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
	$HealthBar/Progress.value = health

func set_phase():
	if health > 1000:
		return
	elif health > 500:
		phase = 2
		play_dash()
	else:
		play_dash()
		phase = 3
		
func play_whirlwind():
#	if not has_node("Whirlwind"):
#		var spell = Whirlwind.instance()
#		spell.name = "Whirlwind"
#		spell.is_attached_to_wind_boss = true
#		add_child(spell)
	for i in range(20):
		var tornado = TornadoProjectile.instance()
		tornado.is_hostile_projectile = true
		tornado.particles_transform = $ShootDirection.transform
		tornado.position =$ShootDirection/Position2D.global_position
		tornado.velocity = Vector2(rand_range(-1,1), rand_range(-1,1))
		get_node("../../../").add_child(tornado)
		yield(get_tree().create_timer(0.05), "timeout")


func diminish_HOT(type):
	start_poison_state()
	var amount_to_diminish
	match type:
		"poison potion I":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.32
	var increment = int(ceil(amount_to_diminish / 4))
	while int(amount_to_diminish) > 0 and not destroyed:
		if amount_to_diminish < increment:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, position)
			amount_to_diminish = 0
		else:
			health -= increment
			InstancedScenes.player_hit_effect(-increment, position)
			amount_to_diminish -= increment
		if health <= 0 and not destroyed:
			destroy()
		yield(get_tree().create_timer(2.0), "timeout")


func start_frozen_state(timer_length):
	boss_sprite.modulate = Color("00c9ff")
	frozen = true
	$Timers/FrozenTimer.start(timer_length)
	#if not attacking and not destroyed:
		#animation_player.play("loop frozen")

func _on_FrozenTimer_timeout():
	frozen = false
	if not poisoned:
		boss_sprite.modulate = Color("00ff00")
		#if not destroyed:
			#animation_player.play("loop")

func start_poison_state():
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	boss_sprite.modulate = Color("009000")
	poisoned = true
	$Timers/PoisonTimer.start()
	#if not attacking and not destroyed:
		#animation_player.play("loop frozen")

func _on_PoisonTimer_timeout():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	poisoned = false
	if not frozen:
		boss_sprite.modulate = Color("ffffff")
		#if not destroyed:
			#animation_player.play("loop")

func start_stunned_state():
	if not destroyed:
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,13)
		$Electricity.show()
		#$BoarBite/CollisionShape2D.set_deferred("disabled", true)
		#animation_player.stop(false)
		$Timers/StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		$Electricity.hide()
		stunned = false
		#animation_player.play()
