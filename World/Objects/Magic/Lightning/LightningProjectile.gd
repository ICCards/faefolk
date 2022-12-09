extends KinematicBody2D

onready var projectile_sprite: AnimatedSprite = $Projectile
onready var sound_effects: AudioStreamPlayer2D = $SoundEffects

var velocity = Vector2(0,0)
var speed = 500
var collided = false
var path
var debuff 
var type
var destroyed: bool = false

func _physics_process(delta):
	if not collided:
		var collision_info = move_and_collide(velocity.normalized() * delta * speed)

func _ready():
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Lightning/electric proj.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	if debuff:
		type = "lightning spell debuff"
	else:
		type = "lightning spell"
	$Hitbox.tool_name = type
	projectile_sprite.play("default")
	
func _on_Area2D_area_entered(area):
	if not destroyed:
		destroyed = true
		projectile_sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		chain_effect(area.name)

func chain_effect(start_name):
	var nodes = []
	for node in Server.world.get_node("NatureObjects").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit(type)
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	for node in Server.world.get_node("Enemies").get_children():
		if not node.destroyed and self.position.distance_to(node.position) < 250 and node.name != start_name:
			node.hit(type)
			nodes.append(Vector3(node.position.x, node.position.y, 0))
	yield(get_tree(), 'idle_frame')
	InstancedScenes.draw_mst_lightning_lines(nodes)
	sound_effects.stream = preload("res://Assets/Sound/Sound effects/Magic/Lightning/zap.mp3")
	sound_effects.volume_db = Sounds.return_adjusted_sound_db("sound", -14)
	sound_effects.play()
	yield(sound_effects, "finished")
	queue_free()

func _on_Timer_timeout():
	if not destroyed:
		destroyed = true
		queue_free()

func _on_Hitbox_body_entered(body):
	if not destroyed:
		yield(get_tree().create_timer(0.1), "timeout")
		destroyed = true
		queue_free()
