extends CharacterBody2D

@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var bunny_sprite: AnimatedSprite2D = $BunnySprite
@onready var _timer: Timer = $Timers/Timer
@onready var animation_player = $AnimationPlayer
@onready var navigation_agent = $NavigationAgent2D

var enemy_name = "bunny"
var is_sleeping: bool = true
var destroyed: bool = false
var stunned: bool = false
var poisoned: bool = false
var frozen: bool = false
var health: int = Stats.BUNNY_HEALTH
var STARTING_HEALTH: int = Stats.BUNNY_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 300.0
var tornado_node = null

var variety

var rng := RandomNumberGenerator.new()
var thread := Thread.new()
var destroy_thread := Thread.new()
var mutex := Mutex.new()


func _ready(): 
	visible = false
	randomize()
	set_attributes()
	_timer.connect("timeout",Callable(self,"_update_pathfinding"))
	navigation_agent.connect("velocity_computed",Callable(self,"move_deferred"))


func set_attributes():
	bunny_sprite.sprite_frames = Images.BunnyVariations[variety-1]
	var randomRadiusScale = randf_range(0.25,1.25)
	$DetectPlayer/CollisionShape2D.scale = Vector2(randomRadiusScale, randomRadiusScale)
	_timer.wait_time = randf_range(2.5, 5.0)
	if Util.chance(50):
		bunny_sprite.flip_h = true

func _update_pathfinding():
	if not thread.is_started() and visible and not destroyed:
		thread.start(Callable(self,"_get_path").bind(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE)))
		if Util.chance(15):
			if not destroyed and not sound_effects.playing:
				sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/bunny/idle.mp3"))
				sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
				sound_effects.call_deferred("play")
	
func _get_path(pos):
	call_deferred("calculate_path", pos)
	
func calculate_path(pos):
	if not destroyed:
		await get_tree().process_frame
		navigation_agent.call_deferred("set_target_position",pos)
		await get_tree().process_frame
	thread.wait_to_finish()

func _physics_process(delta):
	if destroyed or stunned:
		if stunned:
			bunny_sprite.playing = false
		return
	if $DetectPlayer.get_overlapping_areas().size() >= 1 and is_sleeping:
		start_run_state()
		is_sleeping = false
	if is_sleeping:
		bunny_sprite.play("sleep")
		return
	if navigation_agent.is_navigation_finished():
		bunny_sprite.play("idle")
		return
	bunny_sprite.play("walk")
	var target = navigation_agent.get_next_path_position()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	bunny_sprite.flip_h = _get_direction_string() != "Right"

func move_deferred(_velocity: Vector2) -> void:
	call_deferred("move", _velocity)

func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	if frozen:
		set_velocity(_velocity*0.75)
		move_and_slide()
		bunny_sprite.modulate = Color("00c9ff")
	elif poisoned:
		set_velocity(_velocity*0.9)
		move_and_slide()
		bunny_sprite.modulate = Color("009000")
	else:
		set_velocity(_velocity)
		move_and_slide()
		bunny_sprite.modulate = Color("ffffff")


func _get_direction_string() -> String:
	if velocity.x > 0:
		return "Right"
	return "Left"

func hit(tool_name):
	if is_sleeping:
		call_deferred("start_run_state")
		is_sleeping = false
	if tool_name == "blizzard":
		bunny_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start",8)
		return
	elif tool_name == "ice projectile":
		bunny_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start",3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.call_deferred("start")
	call_deferred("start_run_state")
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	$AnimationPlayer.call_deferred("play", "hit")
	if health <= 0 and not destroyed:
		destroy(true)

func destroy(killed_by_player):
	_timer.call_deferred("stop")
	set_physics_process(false)
	bunny_sprite.material = null
	if killed_by_player:
		MapData.remove_object("animal",name)
		PlayerData.player_data["collections"]["mobs"]["bunny"] += 1
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/bunny/death.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
		sound_effects.call_deferred("play")
	destroyed = true
	bunny_sprite.call_deferred("play", "death")
	$AnimationPlayer.call_deferred("play", "death")
	await get_tree().create_timer(0.5).timeout
	InstancedScenes.intitiateItemDrop("raw filet", position, rng.randi_range(0,1))
	InstancedScenes.intitiateItemDrop("cloth", position, rng.randi_range(0,1))
	await $AnimationPlayer.animation_finished
	get_parent().call_deferred("queue_free")

func _on_HurtBox_area_entered(area):
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/bunny/hurt"+str(rng.randi_range(1,4))+".mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		bunny_sprite.set_deferred("modulate", Color("009000"))
		$AnimationPlayer.call_deferred("play", "hit")
		$EnemyPoisonState.call_deferred("start", area.tool_name)
		return
	if area.name == "SwordSwing":
		PlayerData.player_data["skill_experience"]["sword"] += 1
		Stats.decrease_tool_health()
	else:
		PlayerDataHelpers.add_skill_experience(area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.set_deferred("orbit_radius", randf_range(0,20))
		tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(randf_range(-8,8), randf_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	elif area.special_ability == "ice":
		bunny_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 3)
	elif area.special_ability == "poison":
		bunny_sprite.set_deferred("modulate", Color("009000"))
		$EnemyPoisonState.call_deferred("start", "poison arrow")
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		call_deferred("hit", area.tool_name)

func start_run_state():
	navigation_agent.set_deferred("max_speed", 135)
	running_state = true
	$Timers/RunStateTimer.call_deferred("start")
	_timer.set_deferred("wait_time", 0.5)
	_update_pathfinding()

func _on_RunStateTimer_timeout():
	navigation_agent.set_deferred("max_speed", 40)
	running_state = false
	_timer.set_deferred("wait_time", randf_range(2.5, 5.0))

func screen_entered():
	set_deferred("visible", true)

func screen_exited():
	if MapData.world["animal"].has(name):
		MapData.world["animal"][name]["l"] = position/16
		set_deferred("visible", false)
