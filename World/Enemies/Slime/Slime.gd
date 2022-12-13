extends KinematicBody2D

onready var hit_box: Area2D = $SlimeHit
onready var slime_sprite: AnimatedSprite = $SlimeSprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var player = Server.player_node
var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = false
var jumping: bool = false
var jump_delay: bool = false
var start_jump: bool = false
var knocking_back: bool = false
var playing_sound_effect: bool = false
var random_pos := Vector2.ZERO
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var jump_direction := Vector2.ZERO
var jump := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false
var health: int = Stats.SLIME_HEALTH
var STARTING_HEALTH: int = Stats.SLIME_HEALTH
var tornado_node = null
var state = IDLE
var hit_projectiles = []

var rng = RandomNumberGenerator.new()

var JUMP_AMOUNT = 100
var KNOCKBACK_AMOUNT = 180
export var MAX_SPEED = 80
export var ACCELERATION = 200
export var FRICTION = 80

var poison_increment = 0
var amount_to_diminish = 0

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
	slime_sprite.frame = rng.randi_range(0, 13)

	
func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	elif frozen:
		slime_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		slime_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		slime_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)

func _physics_process(delta):
	if destroyed or not visible or stunned:
		return
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and not Server.player_node.state == 5 and not Server.player_node.get_node("Magic").invisibility_active:
		if state != CHASE:
			start_chase_state()
	elif Server.player_node.state == 5 or Server.player_node.get_node("Magic").invisibility_active:
		end_chase_state()
	if knocking_back:
		velocity = velocity.move_toward(knockback * MAX_SPEED * 7, ACCELERATION * delta * 8)
		velocity = move_and_slide(velocity)
		return
	if jumping:
		velocity = velocity.move_toward(jump_direction * MAX_SPEED * 7, ACCELERATION * delta * 8)
		velocity = move_and_slide(velocity)
		return
	if not start_jump:
		var direction = (Server.player_node.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		move(velocity)
		slime_sprite.flip_h = velocity.x > 0
		if (position+Vector2(0,-9)).distance_to(Server.player_node.position) < 120 and not jump_delay and state != IDLE:
			jump_forward()

func jump_forward():
	start_jump = true
	jump_delay = true
	$Timers/JumpDelay.start(rand_range(1.0, 2.5))
	slime_sprite.play("jump")
	yield(slime_sprite, "animation_finished")
	if not cancel_jump and not destroyed:
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/Slime/slime.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		slime_sprite.play("jumping")
		jumping = true
		jump_direction = (Server.player_node.global_position - global_position).normalized()
		yield(slime_sprite, "animation_finished")
		velocity = Vector2.ZERO
	cancel_jump = false
	jumping = false
	start_jump = false
	if not destroyed:
		slime_sprite.play("idle")

func hit(tool_name):
	if tool_name == "blizzard":
		slime_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		slime_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	if state == IDLE:
		start_chase_state()
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/Slime/slimeHit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	InstancedScenes.intitiateItemDrop("slime orb", position, 1)
	destroyed = true
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	if not hit_projectiles.has(area.id):
		if area.id != "":
			hit_projectiles.append(area.id)
		if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
			$HurtBox/AnimationPlayer.play("hit")
			$EnemyPoisonState.start(area.tool_name)
			return
		if area.name == "SwordSwing":
			CollectionsData.skill_experience["sword"] += 1
			Stats.decrease_tool_health()
		else:
			CollectionsData.add_skill_experience(area.tool_name)
		if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
			hit(area.tool_name)
		if area.knockback_vector != Vector2.ZERO:
			if not destroyed:
				$KnockbackParticles.emitting = true
				knocking_back = true
				$Timers/KnockbackTimer.start()
				knockback = area.knockback_vector
				velocity = knockback * 200
				if start_jump:
					slime_sprite.play("idle")
					jumping = false
					start_jump = false
					cancel_jump = true
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

func start_chase_state():
	state = CHASE 
func end_chase_state():
	state = IDLE

func _on_KnockbackTimer_timeout():
	velocity = Vector2.ZERO
	knocking_back = false

func _on_JumpDelay_timeout():
	jump_delay = false

