extends KinematicBody2D

onready var hit_box: Area2D = $SpiderHit
onready var spider_sprite: AnimatedSprite = $Spider
onready var _idle_timer: Timer = $Timers/IdleTimer
onready var _chase_timer: Timer = $Timers/ChaseTimer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var knocking_back: bool = false
var attacking: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var _velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 60.0
var changed_direction_delay: bool = false
var health: int = Stats.DEER_HEALTH
var tornado_node = null
var d := 0.0
var orbit_speed := 5.0
var orbit_radius
var state = IDLE
const KNOCKBACK_SPEED = 100
const ACCELERATION = 180
const FRICTION = 80
const KNOCKBACK_AMOUNT = 70
const MAX_RANDOM_CHASE_DIST = 50

var poison_increment = 0
var amount_to_diminish = 0

enum {
	IDLE,
	WALK,
	CHASE,
	ATTACK,
	DEATH
}
var rng = RandomNumberGenerator.new()

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	randomize()
	#hide()
	orbit_radius = rand_range(30, 50)
#	animation_player.play("loop")
	_idle_timer.wait_time = rand_range(4.0,6.0)
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	navigation_agent.connect("velocity_computed", self, "move") 
	navigation_agent.set_navigation(get_node("../../").nav_node)

func _update_pathfinding_chase():
	random_pos = Vector2(rand_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST), rand_range(-MAX_RANDOM_CHASE_DIST, MAX_RANDOM_CHASE_DIST))
	navigation_agent.set_target_location(Server.player_node.global_position+random_pos)
	
func _update_pathfinding_idle():
	navigation_agent.set_target_location(get_random_pos())

func get_random_pos():
	random_pos = Vector2(rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE), rand_range(-MAX_MOVE_DISTANCE, MAX_MOVE_DISTANCE))
	if Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(position + random_pos)) == -1:
		return position + random_pos
	elif Tiles.cave_wall_tiles.get_cellv(Tiles.cave_wall_tiles.world_to_map(position - random_pos)) == -1:
		return position - random_pos
	else:
		return position
	
func move(velocity: Vector2) -> void:
	if tornado_node or stunned or attacking or destroyed:
		return
	if frozen:
		_velocity = move_and_slide(velocity*0.75)
	elif poisoned:
		_velocity = move_and_slide(velocity*0.9)
	else:
		_velocity = move_and_slide(velocity)

func _physics_process(delta):
	if Server.player_node:
		if not visible or destroyed:
			if chasing:
				end_chase_state()
			return
		if poisoned:
			$PoisonParticles/P1.direction = -_velocity
			$PoisonParticles/P2.direction = -_velocity
			$PoisonParticles/P3.direction = -_velocity
		if stunned or attacking:
			return
		if knocking_back:
			_velocity = _velocity.move_toward(knockback * KNOCKBACK_SPEED * 7, ACCELERATION * delta * 8)
			_velocity = move_and_slide(_velocity)
			return
		if tornado_node:
			orbit_radius += 1.0
			if is_instance_valid(tornado_node):
				d += delta
				position = Vector2(sin(d * orbit_speed) * orbit_radius, cos(d * orbit_speed) * orbit_radius) + tornado_node.global_position
			else: 
				tornado_node = null
		set_direction()
		set_sprite_texture()
		if navigation_agent.is_navigation_finished():
			state = IDLE
			return
		if Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
			end_chase_state()
		if chasing:
			state = CHASE
		else:
			state = WALK
		var target = navigation_agent.get_next_location()
		var move_direction = position.direction_to(target)
		var desired_velocity = move_direction * navigation_agent.max_speed
		var steering = (desired_velocity - _velocity) * delta * 4.0
		_velocity += steering
		navigation_agent.set_velocity(_velocity)
	
	
func set_sprite_texture():
	if state == IDLE:
		if direction == "left":
			$Spider.flip_h = true
			$Spider.play("idle right")
		else:
			$Spider.flip_h = false
			$Spider.play("idle " + direction)
	else:
		if direction == "left":
			$Spider.flip_h = true
			$Spider.play("walk right")
		else:
			$Spider.flip_h = false
			$Spider.play("walk " + direction)
	
func set_direction():
	if not changed_direction_delay:
		if abs(_velocity.x) >= abs(_velocity.y):
			if _velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_delay()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_delay()
		else:
			if _velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_delay()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_delay()


func hit(tool_name):
	if tool_name == "blizzard":
		start_frozen_state(8)
		return
	elif tool_name == "ice projectile":
		start_frozen_state(3)
	elif tool_name == "lightning spell debuff":
		start_stunned_state()
	if state == IDLE or state == WALK:
		start_chase_state()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/hitEnemy.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -8)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	InstancedScenes.intitiateItemDrop("rope", position, 1)
	destroyed = true
	animation_player.play("destroy")
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		diminish_HOT(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != Vector2.ZERO and not attacking:
		$KnockbackParticles.emitting = true
		set_change_direction_delay()
		knocking_back = true
		$Timers/KnockbackTimer.start()
		knockback = area.knockback_vector
		_velocity = knockback * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		orbit_radius = 0
		tornado_node = area
	yield(get_tree().create_timer(0.25), "timeout")
	$KnockbackParticles.emitting = false

func diminish_HOT(type):
	start_poison_state()
	match type:
		"poison potion I":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.08
		"poison potion II":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.2
		"poison potion III":
			amount_to_diminish = Stats.BOAR_HEALTH * 0.32
	poison_increment = int(ceil(amount_to_diminish / 4))
	if amount_to_diminish < poison_increment:
		health -= amount_to_diminish
		InstancedScenes.player_hit_effect(-amount_to_diminish, position)
		amount_to_diminish = 0
	else:
		health -= poison_increment
		InstancedScenes.player_hit_effect(-poison_increment, position)
		amount_to_diminish -= poison_increment
		$Timers/DiminishHOT.start(2)
		if health <= 0 and not destroyed:
			destroy()

func _on_DiminishHOT_timeout():
	if not destroyed:
		if amount_to_diminish < poison_increment:
			health -= amount_to_diminish
			InstancedScenes.player_hit_effect(-amount_to_diminish, position)
			amount_to_diminish = 0
			$Timers/DiminishHOT.stop()
		else:
			health -= poison_increment
			InstancedScenes.player_hit_effect(-poison_increment, position)
			amount_to_diminish -= poison_increment
			$Timers/DiminishHOT.start(2)

func _on_DetectPlayer_area_entered(area):
	start_chase_state()

func start_chase_state():
	start_sound_effects()
	navigation_agent.max_speed = 200
	_idle_timer.stop()
	_chase_timer.start()
	chasing = true
	state = CHASE

func end_chase_state():
	stop_sound_effects()
	navigation_agent.max_speed = 100
	_chase_timer.stop()
	_idle_timer.start()
	chasing = false
	state = IDLE

func _on_EndChaseState_timeout():
	end_chase_state()

func set_change_direction_delay():
	changed_direction_delay = true
	$Timers/ChangeDirectionDelay.start()

func _on_ChangeDirectionDelay_timeout():
	changed_direction_delay = false

func start_frozen_state(timer_length):
	spider_sprite.modulate = Color("00c9ff")
	frozen = true
	$Timers/FrozenTimer.start(timer_length)
#	if not attacking and not destroyed:
#		animation_player.play("loop frozen")

func _on_FrozenTimer_timeout():
	frozen = false
	if not poisoned:
		spider_sprite.modulate = Color("ffffff")
#		if not destroyed:
#			animation_player.play("loop")

func start_poison_state():
	$PoisonParticles/P1.emitting = true
	$PoisonParticles/P2.emitting = true
	$PoisonParticles/P3.emitting = true
	spider_sprite.modulate = Color("009000")
	poisoned = true
	$Timers/PoisonTimer.start()
#	if not attacking and not destroyed:
#		animation_player.play("loop frozen")

func _on_PoisonTimer_timeout():
	$PoisonParticles/P1.emitting = false
	$PoisonParticles/P2.emitting = false
	$PoisonParticles/P3.emitting = false
	poisoned = false
	if not frozen:
		spider_sprite.modulate = Color("ffffff")
#		if not destroyed:
#			animation_player.play("loop")

func start_stunned_state():
	if not destroyed:
		spider_sprite.playing = false
		rng.randomize()
		$Electricity.frame = rng.randi_range(1,13)
		$Electricity.show()
		$Timers/StunnedTimer.start()
		stunned = true

func _on_StunnedTimer_timeout():
	if not destroyed:
		$Electricity.hide()
		stunned = false
		spider_sprite.playing = true


func play_groan_sound_effect():
	rng.randomize()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/attack.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	sound_effects.play()
	yield(sound_effects, "finished")
	playing_sound_effect = false
	start_sound_effects()


func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
#		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Deer/gallop.mp3")
#		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
#		sound_effects.play()


func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.stop()

func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()



func _on_KnockbackTimer_timeout():
	knocking_back = false
