extends CharacterBody2D

@onready var TornadoProjectile = load("res://World/Objects/Magic/Wind/TornadoProjectile.tscn")
@onready var DashGhost = load("res://World/Objects/Magic/Wind/DashGhost.tscn")
@onready var Whirlwind = load("res://World/Objects/Magic/Wind/Whirlwind.tscn")
@onready var LingeringTornado = load("res://World/Objects/Magic/Wind/LingeringTornado.tscn")

@onready var boss_sprite: Sprite2D = $Boss
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var direction: String = "down"
var changing_phase: bool = false
var destroyed: bool = false
var poisoned: bool = false
var frozen: bool = false
var random_pos := Vector2.ZERO
var changed_direction_delay: bool = false
var health: int = 500 #Stats.WIND_BOSS
var STARTING_HEALTH: int = Stats.WIND_BOSS
var state = IDLE

var rng = RandomNumberGenerator.new()

var phase = 1

var MAX_SPEED = 100
var ACCELERATION = 200

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
	navigation_agent.connect("velocity_computed",Callable(self,"move_deferred"))


func _on_AttackTimer_timeout():
	attack()

func attack():
	if state != IDLE and state != TRANSITION_TO_IDLE and not destroyed and not changing_phase:
		if state == TRANSITION_TO_FLY:
			return
		$Sound/Attack.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
		$Sound/Attack.play()
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
		await animation_player.animation_finished
		if destroyed:
			return
		animation_player.play("loop")
		state = FLY
		if phase == 1:
			var spell = TornadoProjectile.instantiate()
			spell.is_hostile_projectile = true
			spell.position =$ShootDirection/Marker2D.global_position
			spell.velocity = Server.player_node.position - position
			get_node("../../Projectiles").add_child(spell)
			await get_tree().create_timer(0.5).timeout
		elif phase == 2:
			for i in range(3):
				var spell = LingeringTornado.instantiate()
				spell.position =$ShootDirection/Marker2D.global_position
				spell.is_hostile_projectile = true
				spell.target = Server.player_node.position
				get_node("../../Projectiles").add_child(spell)
				await get_tree().create_timer(0.5).timeout
		else:
			for i in range(12):
				var spell = LingeringTornado.instantiate()
				spell.position =$ShootDirection/Marker2D.global_position
				spell.is_hostile_projectile = true
				spell.target = get_random_target_pos()
				get_node("../../Projectiles").add_child(spell)
				await get_tree().create_timer(0.05).timeout
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

func move_deferred(_velocity: Vector2) -> void:
	call_deferred("move", _velocity)

func move(_velocity: Vector2) -> void:
	if destroyed and not changing_phase:
		return
#	elif frozen:
#		boss_sprite.modulate = Color("00c9ff")
#		set_velocity(_velocity*0.75)
#		move_and_slide()
#		velocity = velocity
#	elif poisoned:
#		boss_sprite.modulate = Color("009000")
#		set_velocity(_velocity*0.9)
#		move_and_slide()
#		velocity = velocity
#	else:
	#boss_sprite.modulate = Color("ffffff")
	set_velocity(_velocity)
	move_and_slide()

func _physics_process(delta):
	if Server.player_node:
		if destroyed:
			return
		$HealthBar/Progress.value = health
		set_texture()
		if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
			if state == IDLE:
				start_attack_state()
		elif Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
			if state != IDLE and state != TRANSITION_TO_IDLE:
				end_attack_state()
		if state == IDLE or state == TRANSITION_TO_IDLE:
			return
		set_direction_chase_state()
		$ShootDirection.look_at(Server.player_node.position)
		if navigation_agent.is_navigation_finished():
			return
		var target = navigation_agent.get_next_path_position()
		var move_direction = position.direction_to(target)
		var desired_velocity = move_direction * navigation_agent.max_speed
		var steering = (desired_velocity - velocity) * delta * 4.0
		velocity += steering
		navigation_agent.set_velocity(velocity)
#		var direction = (random_pos - global_position).normalized()
#		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#		move(velocity)

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
#	if tool_name == "blizzard":
#		$EnemyFrozenState.start(8)
#		return
#	elif tool_name == "ice projectile":
#		$EnemyFrozenState.start(3)
#		pass
#	elif tool_name == "lightning spell debuff":
#		#$EnemyStunnedState.start()
#		pass
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	if killed_by_player:
		PlayerData.player_data["skill_experience"]["wind"] += 1
		$Sound/Death.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		$Sound/Death.play()
		InstancedScenes.intitiateItemDrop("wind staff", position, 1)
	destroyed = true
	animation_player.play("death")
	$Timers/AttackTimer.stop()
	$Timers/WhirlwindTimer.stop()
	await animation_player.animation_finished
	queue_free()

func _on_HurtBox_area_entered(area):
	$Sound/Hurt.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	$Sound/Hurt.play()
	if area.tool_name == "arrow" or area.tool_name == "fire projectile":
		area.destroy()
	if state == IDLE:
		start_attack_state()
#	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
#		$HurtBox/AnimationPlayer.play("hit")
#		$EnemyPoisonState.start(area.tool_name)
#		return
	if area.name == "SwordSwing":
		PlayerDataHelpers.add_skill_experience("sword")
		Stats.decrease_tool_health()
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
#	if area.special_ability == "fire":
#		InstancedScenes.initiateExplosionParticles(position)
#		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position)
#		health -= Stats.FIRE_DEBUFF_DAMAGE
	set_phase()

func set_phase():
	if health > 700:
		return
	elif health > 350 and phase != 2:
		phase = 2
		play_change_phase()
		await get_tree().create_timer(1.0).timeout
		navigation_agent.max_speed = 70
		$Timers/WhirlwindTimer.start()
		play_whirlwind()
	elif health < 350 and phase != 3:
		phase = 3
		play_change_phase()
		await get_tree().create_timer(1.0).timeout
		navigation_agent.max_speed = 80

func play_change_phase():
	if not changing_phase:
		animation_player.stop(false)
		changing_phase = true
		$Sound/UpgradePhase.volume_db = Sounds.return_adjusted_sound_db("sound",0)
		$Sound/UpgradePhase.play()
		$UpgradePhase.show()
		$UpgradePhase.frame = 0
		$UpgradePhase.play("play")
		await $UpgradePhase.animation_finished
		animation_player.play()
		changing_phase = false
		$UpgradePhase.hide()

func play_whirlwind():
	var spell = Whirlwind.instantiate()
	spell.is_hostile = true
	call_deferred("add_child", spell)

func start_attack_state():
	state = TRANSITION_TO_FLY
	animation_player.play("transition to fly")
	await animation_player.animation_finished
	state = FLY
	animation_player.play("loop")
	
func end_attack_state():
	state = TRANSITION_TO_IDLE
	animation_player.play("transition to idle")
	await animation_player.animation_finished
	state = IDLE
	animation_player.play("loop")
	
func _on_ChangePos_timeout():
	$Timers/ChangePos.start(randf_range(3,5))
	var random_pos = get_random_player_pos()
	navigation_agent.set_target_position(random_pos)

func _on_WhirlwindTimer_timeout():
	if not changing_phase:
		play_whirlwind()
	
func play_wing_flap():
	if state != IDLE:
		$Sound/WingFlap.volume_db = Sounds.return_adjusted_sound_db("sound", 4)
		$Sound/WingFlap.play()

func get_random_target_pos():
	var locs = Tiles.nav_tiles.get_used_cells(0)
	locs.shuffle()
	for loc in locs:
		if Vector2(loc).distance_to(Vector2(Server.player_node.position/16)) < 28:
			return Vector2(loc*16)

func get_random_player_pos():
	var random1 = randf_range(20, 40)
	var random2 = randf_range(10, 30)
	var _player_pos = Server.player_node.position
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


