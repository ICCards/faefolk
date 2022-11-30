extends KinematicBody2D

onready var bear_sprite: Sprite = $Body
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var _idle_timer: Timer = $Timers/IdleTimer
onready var _chase_timer: Timer = $Timers/ChaseTimer
onready var _end_chase_state_timer: Timer = $Timers/EndChaseState
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var hit_box: Position2D = $Position2D


var player = Server.player_node
var direction: String = "down"
var chasing: bool = false
var destroyed: bool = false
var stunned: bool = false
var poisoned: bool = false
var attacking: bool = false
var knocking_back: bool = false
var playing_sound_effect: bool = false
var changed_direction_delay: bool = false
var frozen: bool = false
var random_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var rng = RandomNumberGenerator.new()
var state = IDLE
var health: int = Stats.BEAR_HEALTH
var STARTING_HEALTH: int = Stats.BEAR_HEALTH
var MAX_MOVE_DISTANCE: float = 400.0

const KNOCKBACK_SPEED = 40
const ACCELERATION = 150
const KNOCKBACK_AMOUNT = 70

var tornado_node = null

enum {
	CHASE,
	ATTACK,
	IDLE,
	WALK,
}

func _ready():
	hide()
	randomize()
	animation_player.play("loop")
	_idle_timer.wait_time = rand_range(4.0, 6.0)
	_idle_timer.connect("timeout", self, "_update_pathfinding_idle")
	_chase_timer.connect("timeout", self, "_update_pathfinding_chase")
	_end_chase_state_timer.connect("timeout", self, "end_chase_state")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func _update_pathfinding_idle():
	state = WALK
	navigation_agent.set_target_location(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func _update_pathfinding_chase():
	navigation_agent.set_target_location(player.position)


func _physics_process(delta):
	if not visible or destroyed or stunned: 
		if stunned:
			animation_player.stop(false)
		return
	if knocking_back:
		velocity = velocity.move_toward(knockback * KNOCKBACK_SPEED * 7, ACCELERATION * delta * 8)
		velocity = move_and_slide(velocity)
		return
	set_texture()
	if navigation_agent.is_navigation_finished():
		state = IDLE
		velocity = Vector2.ZERO
		return
	if player.state == 5 or player.get_node("Magic").invisibility_active:
		end_chase_state()
	elif $DetectPlayer.get_overlapping_areas().size() >= 1:
		if state != CHASE and state != ATTACK:
			start_chase_state()
	if state == CHASE and (position + Vector2(0,-26)).distance_to(player.position) < 75:
		state = ATTACK
		swing()
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)

func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or attacking or destroyed:
		return
	if frozen:
		bear_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		bear_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		bear_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)


func play_groan_sound_effect():
	rng.randomize()
	sound_effects.stream = Sounds.bear_grown[rng.randi_range(0, 2)]
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -12)
	sound_effects.play()
	yield(sound_effects, "finished")
	playing_sound_effect = false
	start_sound_effects()

func start_sound_effects():
	if not playing_sound_effect:
		playing_sound_effect = true
		sound_effects.stream = preload("res://Assets/Sound/Sound effects/Animals/Bear/bear pacing.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()

func stop_sound_effects():
	playing_sound_effect = false
	sound_effects.stop()

func set_texture():
	match state:
		CHASE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/gallop/body/" + direction  + ".png")
			$Body/Fangs.texture = load("res://Assets/Images/Animals/Bear/gallop/fangs/" + direction  + ".png")
		WALK:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/walk/body/" + direction  + ".png")
			$Body/Fangs.texture = null
		IDLE:
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/idle/body/" + direction  + ".png")
			$Body/Fangs.texture = null


func swing():
	if not attacking:
		attacking = true
		yield(get_tree().create_timer(0.1), "timeout")
		if destroyed:
			return
		play_groan_sound_effect()
		if (position + Vector2(0,-26)).distance_to(player.position) < 45:
			animation_player.play("bite")
			$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/bite/body/"+ direction +".png")
		else:
			if Util.chance(25):
				animation_player.play("bite")
				$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/bite/body/"+ direction +".png")
			else:
				animation_player.play("swing")
				$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/claw/body/"+ direction +".png")
		yield(animation_player, "animation_finished")
		if destroyed:
			return
		animation_player.play("loop")
		attacking = false
		state = CHASE

func hit(tool_name):
	if state == IDLE or state == WALK:
		start_chase_state()
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	_end_chase_state_timer.stop()
	_end_chase_state_timer.start()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	destroyed = true
	stop_sound_effects()
	$Body/Fangs.texture = null
	$Body/Bear.texture = load("res://Assets/Images/Animals/Bear/death/" + direction  + "/body.png")
	animation_player.play("death")
	yield(get_tree().create_timer(0.5), "timeout")
	InstancedScenes.intitiateItemDrop("raw filet", position, 3)
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	if area.knockback_vector != Vector2.ZERO:
		$KnockbackParticles.emitting = true
		knocking_back = true
		$Timers/KnockbackTimer.start()
		knockback = area.knockback_vector
		velocity = knockback * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.orbit_radius = rand_range(0,20)
		tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(rand_range(-8,8), rand_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	yield(get_tree().create_timer(0.25), "timeout")
	$KnockbackParticles.emitting = false


func _on_KnockbackTimer_timeout():
	knocking_back = false

func _on_EndChaseState_timeout():
	end_chase_state()

func end_chase_state():
	chasing = false
	navigation_agent.max_speed = 100
	stop_sound_effects()
	_idle_timer.start()
	_chase_timer.stop()
	_end_chase_state_timer.stop()
	state = IDLE

func start_chase_state():
	chasing = true
	state = CHASE
	$Body/Fangs.show()
	navigation_agent.max_speed = 240
	start_sound_effects()
	_idle_timer.stop()
	_chase_timer.start()
	_end_chase_state_timer.start()


func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
