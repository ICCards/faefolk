extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var bat_sprite: AnimatedSprite = $BatSprite
onready var hit_box: Area2D = $BatHit

var direction: String = "down"
var destroyed: bool = false
var frozen: bool = false
var stunned: bool = false
var poisoned: bool = false
var chasing: bool = true
var attacking: bool = false
var knockback_vector := Vector2.ZERO
var jump := Vector2.ZERO
var MAX_MOVE_DISTANCE: float = 100.0
var changed_direction_delay: bool = false

var tornado_node = null
var hit_projectiles = []

var health: int = Stats.BAT_HEALTH
var STARTING_HEALTH: int = Stats.BAT_HEALTH
var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

export var MAX_SPEED = 160
export var ACCELERATION = 180
export var FRICTION = 80
export var KNOCKBACK_AMOUNT = 70


func _ready():
	randomize()
	rng.randomize()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/batScreech.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	sound_effects.play()

func _physics_process(delta):
	if destroyed or stunned:
		if stunned:
			bat_sprite.playing = false
		return
	$BatHit.look_at(Server.player_node.position)
	bat_sprite.play("fly " + direction)
	var direction = (Server.player_node.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	move(velocity)

func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	if frozen:
		bat_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		bat_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		bat_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)

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
		if area.knockback_vector != Vector2.ZERO:
			knockback_vector = area.knockback_vector
			velocity = knockback_vector * 200
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
		
		
func hit(tool_name):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/hitEnemy.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	InstancedScenes.intitiateItemDrop("bat wing", position, 1)
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Enemies/monsterdead.wav")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	destroyed = true
	animation_player.play("death")
	yield(animation_player, "animation_finished")
	queue_free()


