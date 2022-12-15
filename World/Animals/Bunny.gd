extends KinematicBody2D

onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
onready var bunny_sprite: AnimatedSprite = $BunnySprite
onready var _timer: Timer = $Timers/Timer
onready var animation_player = $AnimationPlayer
onready var navigation_agent = $NavigationAgent2D

var enemy_name = "bunny"
var is_sleeping: bool = true
var destroyed: bool = false
var stunned: bool = false
var poisoned: bool = false
var frozen: bool = false
var velocity := Vector2.ZERO
var health: int = Stats.BUNNY_HEALTH
var STARTING_HEALTH: int = Stats.BUNNY_HEALTH
var running_state: bool = false
var MAX_MOVE_DISTANCE: float = 500.0
var tornado_node = null

func _ready(): 
	hide()
	randomize()
	set_random_attributes()
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))

func set_random_attributes():
	randomize()
	Images.BunnyVariations.shuffle()
	bunny_sprite.frames = Images.BunnyVariations[0]
	var randomRadiusScale = rand_range(0.5,2.0)
	$DetectPlayer/CollisionShape2D.scale = Vector2(randomRadiusScale, randomRadiusScale)
	_timer.wait_time = rand_range(2.5, 5.0)
	if Util.chance(50):
		bunny_sprite.flip_h = true

func _update_pathfinding() -> void:
	navigation_agent.set_target_location(Util.get_random_idle_pos(position, MAX_MOVE_DISTANCE))

func _physics_process(delta):
	if not visible or destroyed or stunned:
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
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	bunny_sprite.flip_h = _get_direction_string() != "Right"


func move(_velocity: Vector2) -> void:
	if tornado_node or stunned or destroyed:
		return
	if frozen:
		bunny_sprite.modulate = Color("00c9ff")
		velocity = move_and_slide(_velocity*0.75)
	elif poisoned:
		bunny_sprite.modulate = Color("009000")
		velocity = move_and_slide(_velocity*0.9)
	else:
		bunny_sprite.modulate = Color("ffffff")
		velocity = move_and_slide(_velocity)

func _get_direction_string() -> String:
	if velocity.x > 0:
		return "Right"
	return "Left"

func hit(tool_name):
	if is_sleeping:
		start_run_state()
		is_sleeping = false
	if tool_name == "blizzard":
		bunny_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(8)
		return
	elif tool_name == "ice projectile":
		bunny_sprite.modulate = Color("00c9ff")
		$EnemyFrozenState.start(3)
	elif tool_name == "lightning spell debuff":
		$EnemyStunnedState.start()
	start_run_state()
	var dmg = Stats.return_tool_damage(tool_name)
	health -= dmg
	InstancedScenes.player_hit_effect(-dmg, position)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	if health <= 0 and not destroyed:
		destroy()

func destroy():
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Enemies/killAnimal.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	destroyed = true
	bunny_sprite.play("death")
	$AnimationPlayer.play("death")
	yield(get_tree().create_timer(0.5), "timeout")
	InstancedScenes.intitiateItemDrop("raw filet", position, 1)
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _on_HurtBox_area_entered(area):
	sound_effects.stream = load("res://Assets/Sound/Sound effects/Animals/Bunny/rabbit.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", 0)
	sound_effects.play()
	if area.name == "PotionHitbox" and area.tool_name.substr(0,6) == "poison":
		bunny_sprite.modulate = Color("009000")
		$AnimationPlayer.play("hit")
		$EnemyPoisonState.start(area.tool_name)
		return
	if area.name == "SwordSwing":
		CollectionsData.skill_experience["sword"] += 1
		Stats.decrease_tool_health()
	else:
		CollectionsData.add_skill_experience(area.tool_name)
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

func start_run_state():
	navigation_agent.max_speed = 300
	running_state = true
	$Timers/RunStateTimer.start()
	_timer.wait_time = 0.75
	_update_pathfinding()

func _on_RunStateTimer_timeout():
	navigation_agent.max_speed = 200
	running_state = false
	_timer.wait_time = rand_range(2.5, 5.0)

func _on_VisibilityNotifier2D_screen_entered():
	show()
func _on_VisibilityNotifier2D_screen_exited():
	hide()
