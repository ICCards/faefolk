extends Node2D

onready var LightningProjectile = preload("res://World/Objects/Projectiles/LightningProjectile.tscn")
onready var TornadoProjectile = preload("res://World/Objects/Projectiles/TornadoProjectile.tscn")
onready var EarthStrike = preload("res://World/Objects/Projectiles/EarthStrike.tscn")
onready var FireProjectile = preload("res://World/Objects/Projectiles/FireProjectile.tscn")
onready var FlameThrower = preload("res://World/Objects/Projectiles/Flamethrower.tscn")
onready var DashGhost = preload("res://World/Objects/Projectiles/DashGhost.tscn")
onready var LingeringTornado = preload("res://World/Objects/Projectiles/LingeringTornado.tscn")
onready var Earthquake = preload("res://World/Objects/Projectiles/Earthquake.tscn")
onready var Whirlwind = preload("res://World/Objects/Projectiles/Whirlwind.tscn")
onready var IceDefense = preload("res://World/Objects/Projectiles/IceDefense.tscn")
onready var LightningStrike = preload("res://World/Objects/Projectiles/LightningStrike.tscn")
onready var IceProjectile = preload("res://World/Objects/Projectiles/IceProjectile.tscn")
onready var BlizzardFog = preload("res://World/Objects/Projectiles/BlizzardFog.tscn")
onready var EarthGolem = preload("res://World/Objects/Projectiles/EarthGolem.tscn")
onready var EarthStrikeDebuff = preload("res://World/Objects/Projectiles/EarthStrikeDebuff.tscn")

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")

var dashing = false

var player_fire_buff: bool = false

const FIRE_BUFF_LENGTH = 10

enum {
	MOVEMENT, 
	SWINGING,
	EATING,
	FISHING,
	HARVESTING,
	DYING,
	SLEEPING,
	SITTING,
	MAGIC_CASTING
}

signal spell_finished

var animation: String = ""
var direction: String = "DOWN"
var is_casting: bool = false
var flamethrower_active: bool = false
var mouse_left_down: bool = false

var starting_mouse_point
var ending_mouse_point


func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false


func wait_for_cast_release(staff_name):
	if not mouse_left_down:
		cast(staff_name, get_node("../Camera2D/UserInterface/MagicStaffUI").selected_spell)
	elif get_parent().state == DYING:
		return
	else:
		yield(get_tree().create_timer(0.1), "timeout")
		wait_for_cast_release(staff_name)

func cast_spell(staff_name, init_direction):
	if get_node("../Camera2D/UserInterface/MagicStaffUI").validate_spell_cooldown():
		direction = init_direction
		PlayerStats.decrease_energy()
		starting_mouse_point = get_global_mouse_position()
		if get_node("../Camera2D/UserInterface/MagicStaffUI").selected_spell != 2:
			get_parent().state = MAGIC_CASTING
			is_casting = true
			animation = "magic_cast_" + init_direction.to_lower()
			player_animation_player.play("bow draw release")
			composite_sprites.set_player_animation(get_parent().character, animation, "magic staff")
			yield(player_animation_player, "animation_finished" )
		wait_for_cast_release(staff_name)
	else:
		get_parent().state = MOVEMENT


func _physics_process(delta):
	if not is_casting and not flamethrower_active:
		return
	var degrees = int($CastDirection.rotation_degrees) % 360
	$CastDirection.look_at(get_global_mouse_position())
	if $CastDirection.rotation_degrees >= 0:
		if degrees <= 45 or degrees >= 315:
			direction = "RIGHT"
		elif degrees <= 135:
			direction = "DOWN"
		elif degrees <= 225:
			direction = "LEFT"
		else:
			direction = "UP"
	else:
		if degrees >= -45 or degrees <= -315:
			direction = "RIGHT"
		elif degrees >= -135:
			direction = "UP"
		elif degrees >= -225:
			direction = "LEFT"
		else:
			direction = "DOWN"
	if get_parent().state != DYING:
		composite_sprites.set_player_animation(get_parent().character, "magic_cast_" + direction.to_lower(), "magic staff")


func cast(staff_name, spell_index):
	get_node("../Camera2D/UserInterface/MagicStaffUI").start_spell_cooldown()
	PlayerStats.decrease_mana(2)
	match staff_name:
		"lightning staff":
			match spell_index:
				1:
					play_lightning_projectile(false)
				2:
					play_flash_step()
				3:
					play_lightning_projectile(true)
				4:
					play_lightning_strike()
		"fire staff":
			match spell_index:
				1:
					play_fire_projectile(false)
					yield(self, "spell_finished")
				2:
					play_fire_buff()
				3:
					play_fire_projectile(true)
					yield(self, "spell_finished")
				4:
					play_flamethrower()
					yield(self, "spell_finished")
		"wind staff":
			match spell_index:
				1:
					play_wind_projectile()
				2:
					play_dash()
				3:
					play_lingering_tornado()
				4:
					play_whirlwind()
		"ice staff":
			match spell_index:
				1:
					play_ice_projectile(false)
				2:
					play_ice_shield()
				3:
					play_ice_projectile(true)
				4:
					play_blizzard()
		"earth staff":
			match spell_index:
				1:
					play_earth_strike()
				2:
					play_earth_golem()
					yield(self, "spell_finished")
				3:
					play_earth_strike_buff()
				4:
					play_earthquake()
		"health staff":
			match spell_index:
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
	is_casting = false
	if get_parent().state != DYING: 
		get_parent().state = MOVEMENT
		get_parent().direction = direction




# Earth #
func play_earth_strike():
	var spell = EarthStrike.instance()
	get_node("../../../").add_child(spell)
	spell.position = get_global_mouse_position()

func play_earth_golem():
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	var spell = EarthGolem.instance()
	add_child(spell)
	yield(get_tree().create_timer(1.0), "timeout")
	composite_sprites.hide()
	yield(get_tree().create_timer(3.4), "timeout")
	get_node("../Camera2D").start_small_shake()
	yield(get_tree().create_timer(0.5), "timeout")
	composite_sprites.show()
	yield(self, "spell_finished")
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", false)

func play_earth_strike_buff():
	ending_mouse_point = get_global_mouse_position()
	var current_pt = Tiles.valid_tiles.world_to_map(starting_mouse_point) * 32
	if abs(abs(ending_mouse_point.x) - abs(starting_mouse_point.x)) > abs(abs(ending_mouse_point.y) - abs(starting_mouse_point.y)): # Horizontal
		if ending_mouse_point.x > starting_mouse_point.x: # Moving right:
			#var current_pt = starting_mouse_point
			while current_pt.x < ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x += 96
		else: # Moving left
			#var current_pt = starting_mouse_point
			while current_pt.x > ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x -= 96
			
	else: # Vertical 
		if ending_mouse_point.y > starting_mouse_point.y: # Moving down:
			#var current_pt = starting_mouse_point
			while current_pt.y < ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y += 64
		else: # Moving up
			#var current_pt = starting_mouse_point
			while current_pt.y > ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y -= 64
	
func play_earthquake():
	var spell = Earthquake.instance()
	add_child(spell)
	get_node("../Camera2D").start_shake()

# Lightning #

func play_flash_step():
	get_parent().position = get_global_mouse_position()
	composite_sprites.material.set_shader_param("flash_modifier", 0.7)
	yield(get_tree().create_timer(0.2), "timeout")
	composite_sprites.material.set_shader_param("flash_modifier", 0.0)
	$Electricity.show()
	$Electricity.play("play")
	yield($Electricity, "animation_finished")
	$Electricity.play("play")
	yield($Electricity, "animation_finished")
	$Electricity.hide()

func play_lightning_projectile(debuff):
	var spell = LightningProjectile.instance()
	spell.debuff = debuff
	spell.transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").add_child(spell)

func play_lightning_strike():
	var spell = LightningStrike.instance()
	get_node("../../../").add_child(spell)
	spell.position = get_global_mouse_position()

# Ice #

func play_ice_projectile(debuff):
	var spell = IceProjectile.instance()
	spell.debuff = debuff
	spell.projectile_transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").add_child(spell)


func play_ice_shield():
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	var spell = IceDefense.instance()
	add_child(spell)
	yield(self, "spell_finished")
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", false)


func play_blizzard():
	var spell = BlizzardFog.instance()
	spell.position = get_parent().position
	get_node("../../../").add_child(spell)
	yield(get_tree().create_timer(1.0), "timeout")
	for animal in get_node("/root/World/Animals").get_children():
		if not animal.destroyed and get_parent().position.distance_to(animal.position) < 1286:
			animal.hit("blizzard")

# Wind #

func play_lingering_tornado():
	var spell = LingeringTornado.instance()
	spell.particles_transform = $CastDirection.transform
	spell.target = get_global_mouse_position() + Vector2(0,32)
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position 
	get_node("../../../").add_child(spell)

func play_wind_projectile():
	var spell = TornadoProjectile.instance()
	spell.particles_transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").add_child(spell)


func play_dash():
	$DustParticles.emitting = true
	$DustBurst.rotation = (get_parent().input_vector*-1).angle()
	$DustBurst.restart()
	$DustBurst.emitting = true
	set_player_whitened()
	dashing = true
	$GhostTimer.start()
	yield(get_tree().create_timer(0.5), "timeout")
	$DustParticles.emitting = false
	$DustBurst.emitting = false
	dashing = false
	$GhostTimer.stop()

func set_player_whitened():
	composite_sprites.material.set_shader_param("flash_modifier", 0.7)
	yield(get_tree().create_timer(0.5), "timeout")
	composite_sprites.material.set_shader_param("flash_modifier", 0.0)

var body_sprites = ["Arms", "Body"]

func _on_GhostTimer_timeout():
	for sprite_name in body_sprites:
		var sprite = get_node("../CompositeSprites/" + sprite_name)
		var ghost: Sprite = DashGhost.instance()
		get_node("../../").add_child(ghost)
		ghost.global_position = global_position + Vector2(0,-32)
		ghost.texture = sprite.texture
		ghost.hframes = sprite.hframes
		ghost.frame = sprite.frame

func play_whirlwind():
	var spell = Whirlwind.instance()
	add_child(spell)

# Fire #
func play_fire_projectile(debuff):
	for i in range(3):
		var spell = FireProjectile.instance()
		spell.debuff = debuff
		spell.particles_transform = $CastDirection.transform
		spell.position = $CastDirection/Position2D.global_position
		spell.velocity = get_global_mouse_position() - spell.position
		get_node("../../../").add_child(spell)
		yield(get_tree().create_timer(0.35), "timeout")
	emit_signal("spell_finished")


func play_fire_buff():
	player_fire_buff = true
	yield(get_tree().create_timer(FIRE_BUFF_LENGTH), "timeout")
	player_fire_buff = false
	
func play_flamethrower():
	var spell = FlameThrower.instance()
	spell.name = "FlameThrower"
	$CastDirection.add_child(spell)
	spell.position = $CastDirection/Position2D.position
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("spell_finished")

