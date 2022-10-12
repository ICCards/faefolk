extends KinematicBody2D

onready var _timer: Timer = $Timer
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var animation_player: AnimationPlayer = $AnimationPlayer

var player = Server.player_node
var direction: String = "down"
var state = SLEEP
var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var dying: bool = false
var attacking: bool = false
var changed_direction: bool = false
var health: int = Stats.BOAR_HEALTH
var KNOCKBACK_AMOUNT = 300

var directions = ["up", "down", "left", "right"]

enum {
	SLEEP,
	RUN,
	ATTACK
}


func _ready():
	randomize()
	directions.shuffle()
	direction = directions[0]
	animation_player.play("sleep_" + direction)
	_timer.connect("timeout", self, "_update_pathfinding")
	navigation_agent.connect("velocity_computed", self, "move")
	navigation_agent.set_navigation(get_node("/root/World/Navigation2D"))
	
func _update_pathfinding():
	navigation_agent.set_target_location(player.global_position)

func _physics_process(delta):
	if not visible or dying or state == SLEEP:
		return
	set_direction()
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_AMOUNT * delta)
		knockback = move_and_slide(knockback)
		yield(get_tree().create_timer(0.4), "timeout")
		knockback = Vector2.ZERO
#		return
	if state == RUN and (position + Vector2(0,-26)).distance_to(player.position) < 75:
		state = ATTACK
		attack()
		return
	if state != ATTACK:
		animation_player.play("run_" + direction)
	var target = navigation_agent.get_next_location()
	var move_direction = position.direction_to(target)
	var desired_velocity = move_direction * navigation_agent.max_speed
	var steering = (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	navigation_agent.set_velocity(velocity)
	
func attack():
	if not player.state == 5: # player dead
		if not attacking:
			attacking = true
			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack_" + direction)
			yield($AnimationPlayer, "animation_finished")
			attacking = false
			animation_player.play("run_" + direction)
			state = RUN
	else:
		state = RUN

func move(velocity: Vector2) -> void:
	if not dying:
		if knockback == Vector2.ZERO:
			velocity = move_and_slide(velocity)
	
func set_direction():
	if not changed_direction:
		if abs(velocity.x) >= abs(velocity.y):
			if velocity.x >= 0:
				if direction != "right":
					direction = "right"
					set_change_direction_wait()
			else:
				if direction != "left":
					direction = "left"
					set_change_direction_wait()
		else:
			if velocity.y >= 0:
				if direction != "down":
					direction = "down"
					set_change_direction_wait()
			else:
				if direction != "up":
					direction = "up"
					set_change_direction_wait()

func set_change_direction_wait():
	changed_direction = true
	yield(get_tree().create_timer(0.25), "timeout")
	changed_direction = false


func _on_DetectPlayer_area_entered(area):
	_timer.start()
	state = RUN


func _on_HurtBox_area_entered(area):
	$HurtBox/AnimationPlayer.play("hit")
	if state == SLEEP:
		state = RUN
	if area.knockback_vector != null:
		knockback = area.knockback_vector * 100
	if area.name == "SwordSwing":
		Stats.decrease_tool_health()
	health -= Stats.return_sword_damage(area.tool_name)
	if health <= 0 and not dying:
		dying = true
		$Position2D/BoarBite/CollisionShape2D.set_deferred("disabled", true)
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimationPlayer.play("death")
		yield($AnimationPlayer, "animation_finished")
		queue_free()



func _on_VisibilityNotifier2D_screen_entered():
	show()

func _on_VisibilityNotifier2D_screen_exited():
	hide()
