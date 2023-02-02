extends KinematicBody2D

onready var ForageItem = load("res://World/Objects/Nature/Forage/ForageItem.tscn")

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var duck_sprite: AnimatedSprite = $DuckSprite
onready var _timer: Timer = $Timers/Timer
onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D

var enemy_name = "duck"
var is_eating: bool = false
var destroyed: bool = false
var stunned: bool = false
var frozen: bool = false
var poisoned: bool = false
var velocity := Vector2.ZERO
var health: int = Stats.DUCK_HEALTH
var STARTING_HEALTH: int = Stats.DUCK_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 500.0
var tornado_node

var rng := RandomNumberGenerator.new()
var thread := Thread.new()
var destroy_thread := Thread.new()
var mutex := Mutex.new()

var variety

func _ready():
	randomize()
	visible = false
	set_random_attributes()
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move_deferred")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func set_random_attributes():
	$Timers/DropEggTimer.wait_time = rand_range(20, 40)
	duck_sprite.frames = Images.DuckVariations[variety-1]
	_timer.wait_time = rand_range(2.5, 5.0)
	if Util.chance(50):
		duck_sprite.flip_h = true

func _physics_process(delta):
	if not visible or destroyed or is_eating or stunned:
		if stunned:
			duck_sprite.playing = false
		return
	if navigation_agent.is_navigation_finished():
		if running_state or frozen:
			_update_pathfinding()
			return
		if Util.chance(20):
			is_eating = true
			duck_sprite.play("eat")
			yield(duck_sprite, "animation_finished")
			is_eating = false
		else:
			is_eating = true
			duck_sprite.play("idle")
			$Timers/IdleTimer.start(rand_range(1.0, 4.0))
		return
	duck_sprite.play("walk")
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	duck_sprite.flip_h = _get_direction_string(velocity) != "Right"

func move_deferred(_velocity: Vector2) -> void:
	call_deferred("move", _velocity)

func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	if frozen:
		velocity = move_and_slide(_velocity*0.75)
		duck_sprite.modulate = Color("00c9ff")
	elif poisoned:
		velocity = move_and_slide(_velocity*0.9)
		duck_sprite.modulate = Color("009000")
	else:
		velocity = move_and_slide(_velocity)
		duck_sprite.modulate = Color("ffffff")

func _get_direction_string(velocitiy) -> String:
	if velocitiy.x > 0:
		return "Right"
	return "Left"

func _update_pathfinding():
	if not thread.is_active() and visible:
		thread.start(self, "_get_path", Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))
		if Util.chance(5):
			if not destroyed and not sound_effects.playing:
				sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/duck/quack.mp3"))
				sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
				sound_effects.call_deferred("play")
		
func _get_path(pos):
	call_deferred("calculate_path", pos)
	
func calculate_path(pos):
	if not destroyed:
		yield(get_tree(), "idle_frame")
		navigation_agent.call_deferred("set_target_location",pos)
		yield(get_tree(), "idle_frame")
	thread.wait_to_finish()

func _on_HurtBox_area_entered(area):
	sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/duck/quack.mp3"))
	sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
	sound_effects.call_deferred("play")
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		duck_sprite.set_deferred("modulate", Color("009000"))
		$AnimationPlayer.call_deferred("play", "hit")
		$EnemyPoisonState.call_deferred("start", area.tool_name)
		call_deferred("start_run_state")
		return
	if area.name == "SwordSwing":
		PlayerData.player_data["skill_experience"]["sword"] += 1
		Stats.decrease_tool_health()
	else:
		PlayerDataHelpers.add_skill_experience(area.tool_name)
	if area.tool_name != "lightning spell" and area.tool_name != "lightning spell debuff":
		call_deferred("hit", area.tool_name)
	if area.tool_name == "lingering tornado":
		$EnemyTornadoState.set_deferred("orbit_radius", rand_range(0,20))
		tornado_node = area
	if area.special_ability == "fire":
		var randomPos = Vector2(rand_range(-8,8), rand_range(-8,8))
		InstancedScenes.initiateExplosionParticles(position+randomPos)
		InstancedScenes.player_hit_effect(-Stats.FIRE_DEBUFF_DAMAGE, position+randomPos)
		health -= Stats.FIRE_DEBUFF_DAMAGE
	elif area.special_ability == "ice":
		duck_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 3)
	elif area.special_ability == "poison":
		duck_sprite.set_deferred("modulate", Color("009000"))
		$EnemyPoisonState.call_deferred("start", "poison arrow")


func hit(tool_name, var special_ability = ""):
	if tool_name == "blizzard":
		duck_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 8)
		return
	elif tool_name == "ice projectile":
		duck_sprite.set_deferred("modulate", Color("00c9ff"))
		$EnemyFrozenState.call_deferred("start", 3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.call_deferred("start")
	is_eating = false
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
	if killed_by_player:
		MapData.remove_animal(name)
		PlayerData.player_data["collections"]["mobs"]["duck"] += 1
		yield(get_tree().create_timer(rand_range(0.05,0.25)), "timeout")
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/Enemies/killAnimal.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", 0))
		sound_effects.call_deferred("play")
	destroyed = true
	duck_sprite.call_deferred("play", "death")
	$AnimationPlayer.call_deferred("play", "death")
	yield(get_tree().create_timer(0.5), "timeout")
	InstancedScenes.intitiateItemDrop("raw wing", position, 1)
	if Util.chance(50):
		InstancedScenes.intitiateItemDrop("raw egg", position, 1) 
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func start_run_state():
	navigation_agent.set_deferred("max_speed", 300)
	running_state = true
	$Timers/RunStateTimer.call_deferred("start")
	_timer.set_deferred("wait_time", 0.75)
	call_deferred("_update_pathfinding")

func _on_RunStateTimer_timeout():
	navigation_agent.set_deferred("max_speed", 200)
	running_state = false
	_timer.set_deferred("wait_time", rand_range(2.5, 5.0))

func _on_IdleTimer_timeout():
	is_eating = false

func _on_DropEggTimer_timeout():
	if visible and Server.isLoaded and not destroyed and velocity != Vector2.ZERO and not is_eating:
		$Timers/DropEggTimer.set_deferred("wait_time", rand_range(10, 30))
		sound_effects.set_deferred("stream", load("res://Assets/Sound/Sound effects/animals/duck/egg drop.mp3"))
		sound_effects.set_deferred("volume_db", Sounds.return_adjusted_sound_db("sound", -4))
		sound_effects.call_deferred("play")
		var forageItem = ForageItem.instance()
		forageItem.first_placement = true
		forageItem.item_name = "raw egg"
		forageItem.global_position = position
		get_node("../../").call_deferred("add_child", forageItem)
	
func _on_VisibilityNotifier2D_screen_entered():
	set_deferred("visible", true)

func _on_VisibilityNotifier2D_screen_exited():
	if MapData.world["animal"].has(name):
		MapData.world["animal"][name]["l"] = position/32
		set_deferred("visible", false)
