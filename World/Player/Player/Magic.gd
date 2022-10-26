extends Node2D

onready var LightningProjectile = preload("res://World/Objects/Projectiles/LightningProjectile.tscn")
onready var ExplosionProjectile = preload("res://World/Objects/Projectiles/ExplosionProjectile.tscn")
onready var TornadoProjectile = preload("res://World/Objects/Projectiles/TornadoProjectile.tscn")
onready var IceProjectile = preload("res://World/Objects/Projectiles/IceProjectile.tscn")
onready var EarthStrike = preload("res://World/Objects/Projectiles/EarthStrike.tscn")
onready var FireProjectile = preload("res://World/Objects/Projectiles/FireProjectile.tscn")
onready var FlameThrower = preload("res://World/Objects/Projectiles/Flamethrower.tscn")
onready var DashGhost = preload("res://World/Objects/Projectiles/DashGhost.tscn")

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")

var dashing = false

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
	composite_sprites.set_player_animation(get_parent().character, "magic_cast_" + direction.to_lower(), "magic staff")


func cast(staff_name, spell_index):
	get_node("../Camera2D/UserInterface/MagicStaffUI").start_spell_cooldown()
	PlayerStats.decrease_mana(2)
	match staff_name:
		"lightning staff":
			match spell_index:
				1:
					play_lightning_projectile()
				2:
					play_flash_step()
				3:
					pass
				4:
					pass
		"fire staff":
			match spell_index:
				1:
					play_fire_projectile()
					yield(self, "spell_finished")
				2:
					pass
				3:
					play_fire_explosion()
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
					pass
				4:
					play_whirlwind()
		"ice staff":
			match spell_index:
				1:
					play_ice_projectile()
				2:
					play_ice_shield()
				3:
					pass
				4:
					pass
		"earth staff":
			match spell_index:
				1:
					play_earth_strike()
				2:
					pass
				3:
					pass
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

func play_earthquake():
	$Earthquake/Area2D.tool_name = "earthquake"
	$Earthquake/AnimationPlayer.play("play")
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

func play_lightning_projectile():
	var spell = LightningProjectile.instance()
	get_node("../../../").add_child(spell)
	spell.transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position


# Ice #
func play_ice_projectile():
	var spell = IceProjectile.instance()
	get_node("../../../").add_child(spell)
	spell.transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position

func play_ice_shield():
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	$Iceberg.show()
	$Iceberg.animation = "start"
	$Iceberg.play()
	yield($Iceberg, "animation_finished")
	$Iceberg.animation = "idle"
	$Iceberg.play()
	yield($Iceberg, "animation_finished")
	$Iceberg.animation = "end"
	$Iceberg.play()
	yield($Iceberg, "animation_finished")
	$Iceberg.hide()
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", false)


# Wind #
func play_wind_projectile():
	var spell = TornadoProjectile.instance()
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

var body_sprites = ["Shoes", "Shirts", "Pants", "Accessory", "Arms", "HeadAtr", "Body"]

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
	$Whirlwind/Area2D.tool_name = "whirlwind spell"
	$Whirlwind/AnimationPlayer.play("play")

# Fire #
func play_fire_projectile():
	for i in range(3):
		var spell = FireProjectile.instance()
		get_node("../../../").add_child(spell)
		spell.position = $CastDirection/Position2D.global_position
		spell.velocity = get_global_mouse_position() - spell.position
		yield(get_tree().create_timer(0.25), "timeout")
	emit_signal("spell_finished")

func play_fire_explosion():
	for i in range(3):
		var spell = ExplosionProjectile.instance()
		get_node("../../../").add_child(spell)
		spell.position = $CastDirection/Position2D.global_position
		spell.velocity = get_global_mouse_position() - spell.position
		yield(get_tree().create_timer(0.25), "timeout")
	emit_signal("spell_finished")
	
func play_flamethrower():
	var spell = FlameThrower.instance()
	spell.name = "FlameThrower"
	$CastDirection.add_child(spell)
	spell.position = $CastDirection/Position2D.position
	yield(get_tree().create_timer(3.0), "timeout")
	emit_signal("spell_finished")

