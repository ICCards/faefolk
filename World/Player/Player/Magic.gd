extends Node2D

@onready var sound_effects: AudioStreamPlayer = $SoundEffects

@onready var PotionProjectile = load("res://World3D/Objects/Projectiles/PotionProjectile.tscn")

@onready var ArrowProjectile = load("res://World3D/Objects/Projectiles/ArrowProjectile.tscn")

@onready var LightningProjectile = load("res://World3D/Objects/Magic/Lightning/LightningProjectile.tscn")
@onready var LightningStrike = load("res://World3D/Objects/Magic/Lightning/LightningStrike.tscn")
@onready var FlashStep = load("res://World3D/Objects/Magic/Lightning/FlashStep.tscn")

@onready var TornadoProjectile = load("res://World3D/Objects/Magic/Wind/TornadoProjectile.tscn")
@onready var DashGhost = load("res://World3D/Objects/Magic/Wind/DashGhost.tscn")
@onready var LingeringTornado = load("res://World3D/Objects/Magic/Wind/LingeringTornado.tscn")
@onready var Whirlwind = load("res://World3D/Objects/Magic/Wind/Whirlwind.tscn")

@onready var FireProjectile = load("res://World3D/Objects/Magic/Fire/FireProjectile.tscn")
@onready var FlameThrower = load("res://World3D/Objects/Magic/Fire/Flamethrower.tscn")
@onready var FireBuffFront = load("res://World3D/Objects/Magic/Fire/AttachedFlameBehind.tscn")
@onready var FireBuffBehind = load("res://World3D/Objects/Magic/Fire/AttachedFlameFront.tscn")

@onready var EarthStrike = load("res://World3D/Objects/Magic/Earth/EarthStrike.tscn")
@onready var EarthGolem = load("res://World3D/Objects/Magic/Earth/EarthGolem.tscn")
@onready var EarthStrikeDebuff = load("res://World3D/Objects/Magic/Earth/EarthStrikeDebuff.tscn")
@onready var Earthquake = load("res://World3D/Objects/Magic/Earth/Earthquake.tscn")

@onready var IceDefense = load("res://World3D/Objects/Magic/Ice/IceDefense.tscn")
@onready var IceProjectile = load("res://World3D/Objects/Magic/Ice/IceProjectile.tscn")
@onready var BlizzardFog = load("res://World3D/Objects/Magic/Ice/BlizzardFog.tscn")

@onready var DemonMage = load("res://World3D/Objects/Magic/Dark/DemonMage.tscn")
@onready var PortalNode = load("res://World3D/Objects/Magic/Dark/Portal.tscn")

@onready var HealthProjectile = load("res://World3D/Objects/Magic/Health/HealthProjectile.tscn")
@onready var HealthBuff = load("res://World3D/Objects/Magic/Health/HealthBuff.tscn")

@onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
@onready var player_animation_player2 = get_node("../CompositeSprites/AnimationPlayer2")
@onready var composite_sprites = get_node("../CompositeSprites")
var _uuid = load("res://helpers/UUID.gd")
@onready var uuid = _uuid.new()

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

var animation: String = ""
var direction: String = "DOWN"
var movement_direction: String = ""
var current_potion: String = ""
var current_staff_name: String = ""
var is_casting: bool = false
var is_drawing: bool = false
var is_releasing: bool = false
var is_throwing: bool = false
var flamethrower_active: bool = false
var invisibility_active: bool = false
var ice_shield_active: bool = false
var mouse_left_down: bool = false
var mouse_right_down: bool = false
var cancel_attack_pressed: bool = false


var starting_mouse_point
var ending_mouse_point

var thread = Thread.new()

func _ready():
	PlayerData.connect("health_depleted",Callable(self,"player_death"))

func player_death():
	is_casting = false
	is_drawing = false
	is_releasing = false
	

func _input( event ):
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.is_pressed()):
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
		if (event.button_index == 2 and event.is_pressed()):
			mouse_right_down = true
		elif event.button_index == 2 and not event.is_pressed():
			mouse_right_down = false
	elif event is InputEvent:
		if event.is_action_pressed("use_tool"):
			mouse_left_down = true
		elif event.is_action_released("use_tool"):
			mouse_left_down = false
		if event.is_action_pressed("slot2"):
			mouse_right_down = true
		elif event.is_action_released("slot2"):
			mouse_right_down = false
		if event.is_action_pressed("cancel_attack"):
			cancel_attack_pressed = true
		elif event.is_action_released("cancel_attack"):
			cancel_attack_pressed = false

func draw_bow(spell_index):
	if not thread.is_active():
		thread.start(Callable(self,"whoAmIBow").bind(spell_index))
		
func whoAmIBow(spell_index):
	call_deferred("draw_bow_deferred",spell_index)

func draw_bow_deferred(spell_index):
	if validate_bow_requirement(spell_index):
		get_parent().state = MAGIC_CASTING
		is_drawing = true
		animation = "draw_" + get_parent().direction.to_lower()
		player_animation_player.play("bow draw release")
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Bow and arrow/draw.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
		sound_effects.play()
		await player_animation_player.animation_finished
		wait_for_bow_release(spell_index)
	else:
		thread.wait_to_finish()

func validate_bow_requirement(spell_index):
	match spell_index:
		1:
			return PlayerData.returnSufficentCraftingMaterial("arrow", 1)
		2:
			return PlayerData.returnSufficentCraftingMaterial("arrow", 3) and PlayerData.player_data["skill_experience"]["bow"] >= 100
		3:
			return PlayerData.returnSufficentCraftingMaterial("arrow", 1) and PlayerData.player_data["mana"] > 0 and PlayerData.player_data["skill_experience"]["bow"] >= 500
		4:
			return PlayerData.returnSufficentCraftingMaterial("arrow", 2) and PlayerData.player_data["mana"] > 1 and PlayerData.player_data["skill_experience"]["bow"] >= 1000

func wait_for_bow_release(spell_index):
	if not mouse_left_down:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Bow and arrow/release.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
		sound_effects.play()
		PlayerData.change_energy(-1)
		Stats.decrease_tool_health()
		shoot(spell_index)
		is_drawing = false
		is_releasing = true
		animation = "release_" + direction.to_lower()
		composite_sprites.set_player_animation(get_parent().character, animation, "bow release")
		player_animation_player.play("bow draw release")
		await player_animation_player.animation_finished
		is_releasing = false
		get_parent().direction = direction
		get_parent().state = MOVEMENT
		thread.wait_to_finish()
	elif get_parent().state == DYING:
		thread.wait_to_finish()
		return
	elif cancel_attack_pressed or Sounds.current_footsteps_sound == Sounds.swimming:
		is_drawing = false
		thread.wait_to_finish()
		get_parent().state = MOVEMENT
		return
	else:
		await get_tree().create_timer(0.1).timeout
		wait_for_bow_release(spell_index)

func shoot(spell_index):
	if PlayerData.normal_hotbar_mode:
		single_arrow_shot()
	else:
		match spell_index:
			1:
				single_arrow_shot()
			2:
				multi_arrow_shot()
			3: 
				enchanted_arrow_shot()
			4:
				ricochet_arrow_shot()

func ricochet_arrow_shot():
	PlayerData.remove_material("arrow", 2)
	PlayerData.change_mana(-2)
	var arrow = ArrowProjectile.instantiate()
	if get_node("../Magic").player_fire_buff:
		arrow.is_fire_arrow = true
	else:
		arrow.is_fire_arrow = false
	arrow.is_ricochet_shot = true
	arrow.position = $CastDirection/Marker2D.global_position
	arrow.velocity = (get_global_mouse_position() - arrow.position).normalized()
	get_node("../../../").call_deferred("add_child",arrow)


func enchanted_arrow_shot():
	PlayerData.remove_material("arrow", 1)
	PlayerData.change_mana(-1)
	var arrow = ArrowProjectile.instantiate()
	if Util.chance(33):
		arrow.is_fire_arrow = true
	elif Util.chance(33):
		arrow.is_ice_arrow = true
	else:
		arrow.is_poison_arrow = true
	arrow.position = $CastDirection/Marker2D.global_position
	arrow.velocity = (get_global_mouse_position() - arrow.position).normalized()
	get_node("../../../").call_deferred("add_child",arrow)

func single_arrow_shot():
	PlayerData.remove_material("arrow", 1)
	var arrow = ArrowProjectile.instantiate()
	if get_node("../Magic").player_fire_buff:
		arrow.is_fire_arrow = true
	else:
		arrow.is_fire_arrow = false
	arrow.position = $CastDirection/Marker2D.global_position
	arrow.velocity = (get_global_mouse_position() - arrow.position).normalized()
	get_node("../../../").call_deferred("add_child", arrow)


func multi_arrow_shot():
	PlayerData.remove_material("arrow", 3)
	for i in range(3):
		var arrow = ArrowProjectile.instantiate()
		if get_node("../Magic").player_fire_buff:
			arrow.is_fire_arrow = true
		else:
			arrow.is_fire_arrow = false
		arrow.position = $CastDirection/Marker2D.global_position
		if i == 0:
			arrow.velocity = (get_global_mouse_position() - arrow.position).normalized()
		elif i == 1: 
			arrow.velocity = ((get_global_mouse_position()-arrow.position).normalized()+Vector2(0.25,0.25)).normalized()
		elif i == 2:
			arrow.velocity = ((get_global_mouse_position()-arrow.position).normalized()-Vector2(0.25,0.25)).normalized()
		get_node("../../../").call_deferred("add_child", arrow)


func wait_for_cast_release(staff_name,spell_index):
	if not mouse_left_down and not get_parent().state == DYING:
		if PlayerData.normal_hotbar_mode:
			cast(staff_name, 1)
		else:
			cast(staff_name, spell_index)
	elif get_parent().state == DYING:
		thread.wait_to_finish()
		return
	elif cancel_attack_pressed or Sounds.current_footsteps_sound == Sounds.swimming:
		is_casting = false
		thread.wait_to_finish()
		get_parent().state = MOVEMENT
		return
	else:
		await get_tree().create_timer(0.1).timeout
		wait_for_cast_release(staff_name, spell_index)

func cast_spell(staff_name, spell_index):
	if not thread.is_active():
		thread.start(Callable(self,"whoAmIMagic").bind([staff_name,spell_index]))

func whoAmIMagic(staff_and_spell_index):
	call_deferred("cast_spell_deferred", staff_and_spell_index)

func cast_spell_deferred(staff_and_spell_index):
	if validate_magic_cast_requirements(staff_and_spell_index[1]):
		starting_mouse_point = get_global_mouse_position()
		if staff_and_spell_index[1] != 2 or PlayerData.normal_hotbar_mode:
			get_parent().state = MAGIC_CASTING
			current_staff_name = staff_and_spell_index[0]
			is_casting = true
			animation = "magic_cast_" + get_parent().direction.to_lower()
			player_animation_player.play("bow draw release")
			await player_animation_player.animation_finished
		wait_for_cast_release(staff_and_spell_index[0],staff_and_spell_index[1])
	else:
		thread.wait_to_finish()


func validate_magic_cast_requirements(spell_index):
	if PlayerData.normal_hotbar_mode:
		return PlayerData.player_data["mana"] >= 1 and get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").validate_spell_cooldown(1)
	else:
		match spell_index:
			1:
				return PlayerData.player_data["mana"] >= 1 and get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").validate_spell_cooldown(1)
			2:
				return PlayerData.player_data["mana"] >= 2 and get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").validate_spell_cooldown(2)
			3:
				return PlayerData.player_data["mana"] >= 5 and get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").validate_spell_cooldown(3)
			4:
				return PlayerData.player_data["mana"] >= 10 and get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").validate_spell_cooldown(4)


func _physics_process(delta):
	if (is_casting or is_drawing or is_throwing) and not PlayerData.viewMapMode:
		$AimDownSightLine.show()
		$CastDirection.look_at(get_global_mouse_position())
		var start_pt = $CastDirection/Marker2D.global_position-get_node("../").global_position
		var end_pt = get_local_mouse_position()
		$AimDownSightLine.points = [start_pt, end_pt]
	else:
		$AimDownSightLine.hide()
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
	if is_casting and get_parent().state != DYING:
		if get_parent().cast_movement_direction == "":
			player_animation_player2.stop(false)
			composite_sprites.set_player_animation(get_parent().character, "magic_cast_"+direction.to_lower(), current_staff_name)
		else:
			player_animation_player2.play("walk legs")
			composite_sprites.set_player_animation(get_parent().character, "magic_cast_"+direction.to_lower()+"_"+get_parent().cast_movement_direction, current_staff_name)
	if is_drawing and get_parent().state != DYING:
		if get_parent().cast_movement_direction == "":
			player_animation_player2.stop(false)
			composite_sprites.set_player_animation(get_parent().character, "draw_"+direction.to_lower(), "bow")
		else:
			player_animation_player2.play("walk legs")
			composite_sprites.set_player_animation(get_parent().character, "draw_"+direction.to_lower()+"_"+get_parent().cast_movement_direction, "bow")
	if is_releasing and get_parent().state != DYING:
		composite_sprites.set_player_animation(get_parent().character, "release_" + direction.to_lower(), "bow release")
	if is_throwing and get_parent().state != DYING:
		if get_parent().cast_movement_direction == "":
			player_animation_player2.stop(false)
			composite_sprites.set_player_animation(get_parent().character, "throw_" + direction.to_lower(), current_potion)
		else:
			player_animation_player2.play("walk legs")
			composite_sprites.set_player_animation(get_parent().character, "throw_"+direction.to_lower()+"_"+get_parent().cast_movement_direction, current_potion)

func throw_potion(potion_name, init_direction):
	PlayerData.remove_single_object_from_hotbar()
	is_throwing = true
	current_potion = potion_name
	direction = init_direction
	get_parent().state = MAGIC_CASTING
	composite_sprites.set_player_animation(get_parent().character, "throw_" + direction.to_lower(), potion_name)
	player_animation_player.play("bow draw release")
	await get_tree().create_timer(0.3).timeout
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Potion/throw.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	await player_animation_player.animation_finished
	throw(potion_name)
	is_throwing = false
	get_parent().state = MOVEMENT
	get_parent().direction = direction
	
func throw(potion_name):
	var potion = PotionProjectile.instantiate()
	potion.potion_name = potion_name
	potion.particles_transform = $CastDirection.transform
	potion.target = get_global_mouse_position()
	potion.position = $CastDirection/Marker2D.global_position
	get_node("../../../").add_child(potion)


func cast(staff_name, spell_index):
	get_node("../Camera2D/UserInterface/CombatHotbar/MagicSlots").start_spell_cooldown(spell_index)
	await get_tree().idle_frame
	match spell_index:
		1:
			PlayerData.change_mana(-1)
		2:
			PlayerData.change_mana(-2)
		3:
			PlayerData.change_mana(-5)
		4:
			PlayerData.change_mana(-10)
	match staff_name:
		"electric staff":
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
					await self.spell_finished
				2:
					play_fire_buff()
				3:
					play_fire_projectile(true)
					await self.spell_finished
				4:
					play_flamethrower()
					await self.spell_finished
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
					await self.spell_finished
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
	thread.wait_to_finish()


func set_invisibility():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Dark/invisibility.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$Tween.interpolate_property(composite_sprites.get_node("Body"), "modulate:a", 1.0, 0.15, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Arms"), "modulate:a", 1.0, 0.15, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Legs"), "modulate:a", 1.0, 0.15, 0.5, 3, 1)
	$Tween.start()
	invisibility_active = true
	await get_tree().create_timer(10.0).timeout
	invisibility_active = false
	$Tween.interpolate_property(composite_sprites.get_node("Body"), "modulate:a", 0.15, 1.0, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Arms"), "modulate:a", 0.15, 1.0, 0.5, 3, 1)
	$Tween.start()
	$Tween.interpolate_property(composite_sprites.get_node("Legs"), "modulate:a", 0.15, 1.0, 0.5, 3, 1)
	$Tween.start()


# Dark magic #
func set_portal():
	if Server.world.name.substr(0,4) == "Cave":
		if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.local_to_map(get_global_mouse_position())) != -1:
			return
	if not portal_1_position and not portal_2_position:
		portal_1_position = get_global_mouse_position()
		var spell = PortalNode.instantiate()
		get_node("../../..").add_child(spell)
		spell.name = "Portal1"
		spell.position = get_global_mouse_position()
	elif portal_1_position and not portal_2_position:
		portal_2_position = get_global_mouse_position()
		var spell = PortalNode.instantiate()
		get_node("../../..").add_child(spell)
		spell.name = "Portal2"
		spell.position = get_global_mouse_position()
	elif portal_1_position and portal_2_position:
		get_node("../../../Projectiles/Portal1").queue_free()
		get_node("../../../Portal2").queue_free()
		portal_2_position = null
		portal_1_position = get_global_mouse_position()
		var spell = PortalNode.instantiate()
		get_node("../../..").add_child(spell)
		await get_tree().idle_frame
		spell.name = "Portal1"
		spell.position = get_global_mouse_position()

func spawn_demon_mage(debuff):
	var spell = DemonMage.instantiate()
	get_node("../../../").add_child(spell)
	spell.debuff = debuff
	spell.position = get_global_mouse_position()

# Earth #
func play_earth_strike():
	var spell = EarthStrike.instantiate()
	get_node("../../../").add_child(spell)
	spell.position = get_global_mouse_position()

func play_earth_golem():
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	var spell = EarthGolem.instantiate()
	add_child(spell)
	await get_tree().create_timer(1.0).timeout
	composite_sprites.hide()
	await get_tree().create_timer(2.0).timeout
	get_node("../Camera2D").start_small_shake()
	await get_tree().create_timer(0.5).timeout
	composite_sprites.show()
	await self.spell_finished
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", false)

func play_earth_strike_buff():
	ending_mouse_point = get_global_mouse_position()
	var current_pt = Tiles.valid_tiles.local_to_map(starting_mouse_point) * 32
	if abs(abs(ending_mouse_point.x) - abs(starting_mouse_point.x)) > abs(abs(ending_mouse_point.y) - abs(starting_mouse_point.y)): # Horizontal
		if ending_mouse_point.x > starting_mouse_point.x: # Moving right:
			while current_pt.x < ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instantiate()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x += 96
				await get_tree().create_timer(0.1).timeout
		else: # Moving left
			while current_pt.x > ending_mouse_point.x:
				var spell = EarthStrikeDebuff.instantiate()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.x -= 96
				await get_tree().create_timer(0.1).timeout
	else: # Vertical 
		if ending_mouse_point.y > starting_mouse_point.y: # Moving down:
			while current_pt.y < ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instantiate()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y += 64
				await get_tree().create_timer(0.1).timeout
		else: # Moving up
			while current_pt.y > ending_mouse_point.y:
				var spell = EarthStrikeDebuff.instantiate()
				spell.position = current_pt
				get_node("../../../").add_child(spell)
				current_pt.y -= 64
				await get_tree().create_timer(0.1).timeout
	
func play_earthquake():
	var spell = Earthquake.instantiate()
	add_child(spell)

# Lightning #

func play_flash_step():
	var mouse_pos = get_global_mouse_position()
	if Server.world.name.substr(0,4) == "Cave":
		if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.local_to_map(mouse_pos)) != -1:
			return
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Magic/Lightning/teleport.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -16)
	sound_effects.play()
	await get_tree().create_timer(0.2).timeout
	get_parent().position = mouse_pos
	composite_sprites.material.set_shader_parameter("flash_modifier", 0.7)
	await get_tree().create_timer(0.2).timeout
	composite_sprites.material.set_shader_parameter("flash_modifier", 0.0)
	var spell = FlashStep.instantiate()
	add_child(spell)

func play_lightning_projectile(debuff):
	var spell = LightningProjectile.instantiate()
	spell.debuff = debuff
	spell.transform = $CastDirection.transform
	spell.position = $CastDirection/Marker2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").add_child(spell)

func play_lightning_strike():
	var spell = LightningStrike.instantiate()
	get_node("../../../").add_child(spell)
	spell.position = get_global_mouse_position()

# Ice #

func play_ice_projectile(debuff):
	var spell = IceProjectile.instantiate()
	spell.debuff = debuff
	spell.projectile_transform = $CastDirection.transform
	spell.position = $CastDirection/Marker2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../Projectiles").add_child(spell)


func play_ice_shield():
	ice_shield_active = true
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", true)
	var spell = IceDefense.instantiate()
	add_child(spell)
	await self.spell_finished
	ice_shield_active = false
	get_node("../Area2Ds/HurtBox/CollisionShape2D").set_deferred("disabled", false)


func play_blizzard():
	var spell = BlizzardFog.instantiate()
	spell.position = get_parent().position
	get_node("../../../Projectiles").add_child(spell)


# Wind #

func play_lingering_tornado():
	var spell = LingeringTornado.instantiate()
	spell.particles_transform = $CastDirection.transform
	spell.target = get_global_mouse_position() + Vector2(0,32)
	spell.position = $CastDirection/Marker2D.global_position
	get_node("../../../Projectiles").call_deferred("add_child", spell)

func play_wind_projectile():
	var spell = TornadoProjectile.instantiate()
	spell.position = $CastDirection/Marker2D.global_position
	spell.velocity = get_global_mouse_position() - spell.position
	get_node("../../../").call_deferred("add_child", spell)

func play_dash():
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Magic/Wind/dash.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -16))
	sound_effects.call_deferred("play")
	$DustParticles.set_deferred("emitting", true)
	$DustBurst.set_deferred("rotation", (get_parent().input_vector*-1).angle())
	$DustBurst.call_deferred("restart")
	$DustBurst.set_deferred("emitting", true)
	set_player_whitened()
	dashing = true
	$GhostTimer.call_deferred("start")
	await get_tree().create_timer(0.5).timeout
	$DustParticles.set_deferred("emitting", false)
	$DustBurst.set_deferred("emitting", false)
	dashing = false
	$GhostTimer.call_deferred("stop")

func set_player_whitened():
	composite_sprites.material.call_deferred("set_shader_parameter", "flash_modifier", 0.7)
	await get_tree().create_timer(0.5).timeout
	composite_sprites.material.call_deferred("set_shader_parameter", "flash_modifier", 0.0)

var body_sprites = ["Arms", "Body"]

func _on_GhostTimer_timeout():
	for sprite_name in body_sprites:
		var sprite = get_node("../CompositeSprites/" + sprite_name)
		var ghost: Sprite2D = DashGhost.instantiate()
		get_node("../../../").call_deferred("add_child", ghost)
		ghost.global_position = global_position + Vector2(0,-32)
		ghost.texture = sprite.texture
		ghost.hframes = sprite.hframes
		ghost.frame = sprite.frame

func play_whirlwind():
	var spell = Whirlwind.instantiate()
	call_deferred("add_child", spell)

# Fire #
func play_fire_projectile(debuff):
	for i in range(3):
		var spell = FireProjectile.instantiate()
		spell.debuff = debuff
		spell.position = $CastDirection/Marker2D.global_position
		spell.velocity = get_global_mouse_position() - spell.position
		get_node("../../../Projectiles").call_deferred("add_child", spell)
		await get_tree().create_timer(0.35).timeout
	emit_signal("spell_finished")


func play_fire_buff():
	var spell = FireBuffFront.instantiate()
	spell.name = "FIREBUFF"
	get_node("../").call_deferred("add_child", spell)
	var spell2 = FireBuffBehind.instantiate()
	get_node("../").call_deferred("add_child", spell2)
	player_fire_buff = true
	await get_tree().create_timer(FIRE_BUFF_LENGTH+0.25).timeout
	if not get_node("../").has_node("FIREBUFF"):
		player_fire_buff = false
	
func play_flamethrower():
	var spell = FlameThrower.instantiate()
	spell.name = "FlameThrower"
	$CastDirection.call_deferred("add_child", spell)
	spell.position = $CastDirection/Marker2D.position
	await get_tree().create_timer(4.0).timeout
	emit_signal("spell_finished")

