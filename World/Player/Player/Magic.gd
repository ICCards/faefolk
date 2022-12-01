extends Node2D

onready var sound_effects: AudioStreamPlayer = $SoundEffects

onready var LightningProjectile = preload("res://World/Objects/Magic/Lightning/LightningProjectile.tscn")
onready var LightningStrike = preload("res://World/Objects/Magic/Lightning/LightningStrike.tscn")
onready var FlashStep = preload("res://World/Objects/Magic/Lightning/FlashStep.tscn")

onready var TornadoProjectile = preload("res://World/Objects/Magic/Wind/TornadoProjectile.tscn")
onready var DashGhost = preload("res://World/Objects/Magic/Wind/DashGhost.tscn")
onready var LingeringTornado = preload("res://World/Objects/Magic/Wind/LingeringTornado.tscn")
onready var Whirlwind = preload("res://World/Objects/Magic/Wind/Whirlwind.tscn")

onready var FireProjectile = preload("res://World/Objects/Magic/Fire/FireProjectile.tscn")
onready var FlameThrower = preload("res://World/Objects/Magic/Fire/Flamethrower.tscn")
onready var FireBuffFront = preload("res://World/Objects/Magic/Fire/AttachedFlameBehind.tscn")
onready var FireBuffBehind = preload("res://World/Objects/Magic/Fire/AttachedFlameFront.tscn")

onready var EarthStrike = preload("res://World/Objects/Magic/Earth/EarthStrike.tscn")
onready var EarthGolem = preload("res://World/Objects/Magic/Earth/EarthGolem.tscn")
onready var EarthStrikeDebuff = preload("res://World/Objects/Magic/Earth/EarthStrikeDebuff.tscn")
onready var Earthquake = preload("res://World/Objects/Magic/Earth/Earthquake.tscn")

onready var IceDefense = preload("res://World/Objects/Magic/Ice/IceDefense.tscn")
onready var IceProjectile = preload("res://World/Objects/Magic/Ice/IceProjectile.tscn")
onready var BlizzardFog = preload("res://World/Objects/Magic/Ice/BlizzardFog.tscn")

onready var DemonMage = preload("res://World/Objects/Magic/Dark/DemonMage.tscn")
onready var PortalNode = preload("res://World/Objects/Magic/Dark/Portal.tscn")

onready var HealthProjectile = preload("res://World/Objects/Magic/Health/HealthProjectile.tscn")
onready var HealthBuff = preload("res://World/Objects/Magic/Health/HealthBuff.tscn")

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var player_animation_player2 = get_node("../CompositeSprites/AnimationPlayer2")
onready var composite_sprites = get_node("../CompositeSprites")

var dashing = false
var player_fire_buff: bool = false

var portal_1_position = null
var portal_2_position = null

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
	MAGIC_CASTING,
	THROWING
}

signal spell_finished

var is_staff_held: bool = false

var animation: String = ""
var direction: String = "DOWN"
var movement_direction: String = ""
var is_casting: bool = false
var flamethrower_active: bool = false
var invisibility_active: bool = false
var mouse_left_down: bool = false

var starting_mouse_point
var ending_mouse_point


func _input( event ):
	if is_staff_held:
		#$AimDownSightLine.show()
		$CastDirection.look_at(get_global_mouse_position())
		var start_pt = $CastDirection.position
		var end_pt = get_local_mouse_position()
		$AimDownSightLine.points = [start_pt, end_pt]
	else:
		$AimDownSightLine.hide()
		
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
	yield(get_tree(), "idle_frame")
	if get_node("../Camera2D/UserInterface/MagicStaffUI").validate_spell_cooldown():
		direction = init_direction
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
#	if not is_casting and not flamethrower_active:
#		return
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
	if get_parent().state != DYING and is_casting:
		if get_parent().cast_movement_direction == "":
			player_animation_player2.stop(false)
			composite_sprites.set_player_animation(get_parent().character, "magic_cast_"+direction.to_lower(), "magic staff")
		else:
			player_animation_player2.play("walk legs")
			composite_sprites.set_player_animation(get_parent().character, "magic_cast_"+direction.to_lower()+"_"+get_parent().cast_movement_direction, "magic staff")


func cast(staff_name, spell_index):
	get_node("../Camera2D/UserInterface/MagicStaffUI").start_spell_cooldown()
	match spell_index:
		1:
			PlayerStats.decrease_mana(1)
		2:
			PlayerStats.decrease_mana(2)
		3:
			PlayerStats.decrease_mana(5)
		4:
			PlayerStats.decrease_mana(10)
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
		"dark magic staff":
			match spell_index:
				1:
					spawn_demon_mage(false)
				2:
					set_invisibility()
				3:
					spawn_demon_mage(true)
				4:
					set_portal()
	is_casting = false
	if get_parent().state != DYING: 
		get_parent().state = MOVEMENT
		get_parent().direction = direction


func set_invisibility():
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Dark/invisibility.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$Tween.interpolate_property(composite_sprites.get_node("Body"), "modulate:a", 1.0, 0.15, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Arms"), "modulate:a", 1.0, 0.15, 0.5, 3, 1)
	$Tween.start()
	invisibility_active = true
	yield(get_tree().create_timer(10.0), "timeout")
	invisibility_active = false
	$Tween.interpolate_property(composite_sprites.get_node("Body"), "modulate:a", 0.15, 1.0, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Arms"), "modulate:a", 0.15, 1.0, 0.5, 3, 1)
	$Tween.start()


# Dark magic #
func set_portal():
	if not portal_1_position and not portal_2_position:
		portal_1_position = get_global_mouse_position()
		var spell = PortalNode.instance()
		get_node("../../../Projectiles").add_child(spell)
		spell.name = "Portal1"
		spell.position = get_global_mouse_position()
	elif portal_1_position and not portal_2_position:
		portal_2_position = get_global_mouse_position()
		var spell = PortalNode.instance()
		get_node("../../../Projectiles").add_child(spell)
		spell.name = "Portal2"
		spell.position = get_global_mouse_position()
	elif portal_1_position and portal_2_position:
		get_node("../../../Projectiles/Portal1").queue_free()
		get_node("../../../Projectiles/Portal2").queue_free()
		portal_2_position = null
		portal_1_position = get_global_mouse_position()
		var spell = PortalNode.instance()
		get_node("../../../Projectiles").add_child(spell)
		yield(get_tree(), "idle_frame")
		spell.name = "Portal1"
		spell.position = get_global_mouse_position()

func spawn_demon_mage(debuff):
	var spell = DemonMage.instance()
	get_node("../../../").add_child(spell)
	spell.debuff = debuff
	spell.position = get_global_mouse_position()

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
	yield(get_tree().create_timer(2.0), "timeout")
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
			while current_pt.x < ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x += 96
				yield(get_tree().create_timer(0.1), "timeout")
		else: # Moving left
			while current_pt.x > ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x -= 96
				yield(get_tree().create_timer(0.1), "timeout")
	else: # Vertical 
		if ending_mouse_point.y > starting_mouse_point.y: # Moving down:
			while current_pt.y < ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y += 64
				yield(get_tree().create_timer(0.1), "timeout")
		else: # Moving up
			while current_pt.y > ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instance()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y -= 64
				yield(get_tree().create_timer(0.1), "timeout")
	
func play_earthquake():
	var spell = Earthquake.instance()
	add_child(spell)

# Lightning #

func play_flash_step():
	var mouse_pos = get_global_mouse_position()
	if Server.world.name.substr(0,4) == "Cave":
		if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(mouse_pos)) != -1:
			return
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Lightning/teleport.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	sound_effects.play()
	yield(get_tree().create_timer(0.2), "timeout")
	get_parent().position = mouse_pos
	composite_sprites.material.set_shader_param("flash_modifier", 0.7)
	yield(get_tree().create_timer(0.2), "timeout")
	composite_sprites.material.set_shader_param("flash_modifier", 0.0)
	var spell = FlashStep.instance()
	add_child(spell)

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
	get_node("../../../Projectiles").add_child(spell)


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


# Wind #

func play_lingering_tornado():
	var spell = LingeringTornado.instance()
	spell.particles_transform = $CastDirection.transform
	spell.target = get_global_mouse_position() + Vector2(0,32)
	spell.position = $CastDirection/Position2D.global_position
	get_node("../../../").add_child(spell)

func play_wind_projectile():
	var spell = TornadoProjectile.instance()
	#spell.particles_transform = $CastDirection.transform
	spell.position = $CastDirection/Position2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").add_child(spell)

func play_dash():
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Wind/dash.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	sound_effects.play()
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
	var spell = FireBuffFront.instance()
	get_node("../").add_child(spell)
	var spell2 = FireBuffBehind.instance()
	get_node("../").add_child(spell2)
	player_fire_buff = true
	yield(get_tree().create_timer(FIRE_BUFF_LENGTH), "timeout")
	player_fire_buff = false
	
func play_flamethrower():
	var spell = FlameThrower.instance()
	spell.name = "FlameThrower"
	$CastDirection.add_child(spell)
	spell.position = $CastDirection/Position2D.position
	yield(get_tree().create_timer(4.0), "timeout")
	emit_signal("spell_finished")

