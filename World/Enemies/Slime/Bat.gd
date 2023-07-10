extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bat_sprite: AnimatedSprite2D = $BatSprite
@onready var hit_box: Area2D = $BatHit

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


var health: int = Stats.BAT_HEALTH
var STARTING_HEALTH: int = Stats.BAT_HEALTH
var rng = RandomNumberGenerator.new()

@export var MAX_SPEED = 80
@export var ACCELERATION = 90
@export var FRICTION = 40
@export var KNOCKBACK_AMOUNT = 30


func _ready():
	randomize()
	rng.randomize()
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/batScreech.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -4)
	sound_effects.play()

func _physics_process(delta):
	if destroyed or stunned:
		if stunned:
			bat_sprite.playing = false
		return
	$BatHit.look_at(Server.player_node.position)
	bat_sprite.play(direction)
	var dir = (Server.player_node.global_position - global_position).normalized()
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	move(velocity)

func move(_velocity: Vector2) -> void:
	if $EnemyTornadoState.tornado_node or stunned or destroyed:
		return
	if frozen:
		bat_sprite.modulate = Color("00c9ff")
		set_velocity(_velocity*0.75)
		move_and_slide()
	elif poisoned:
		bat_sprite.modulate = Color("009000")
		set_velocity(_velocity*0.9)
		move_and_slide()
	else:
		bat_sprite.modulate = Color("ffffff")
		set_velocity(_velocity)
		move_and_slide()

func _on_HurtBox_area_entered(area):
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		$HurtBox/AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		PlayerData.player_data["skill_experience"]["sword"] += 1
		Stats.decrease_tool_health()
	else:
		PlayerDataHelpers.add_skill_experience(area.tool_name)
	if area.knockback_vector != Vector2.ZERO:
		knockback_vector = area.knockback_vector
		velocity = knockback_vector * 200
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		hit(area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(randf_range(-8,8), randf_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	elif area.special_ability == "ice":
		$EnemyFrozenState.start(3)
	elif area.special_ability == "poison":
		$EnemyPoisonState.start("poison arrow")
	if area.tool_name == "arrow" or area.tool_name == "fire projectile":
		area.destroy()
		
		
func hit(tool_name):
	if tool_name == "blizzard":
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/hitEnemy.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	$HurtBox/AnimationPlayer.play("hit")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	if killed_by_player:
		PlayerData.player_data["collections"]["mobs"]["bat"] += 1
		sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/monsterdead.mp3")
		sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
		sound_effects.play()
		InstancedScenes.intitiateItemDrop("bat wing", position, 1)
	destroyed = true
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()


