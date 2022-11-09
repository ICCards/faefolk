extends Node2D

onready var PotionProjectile = preload("res://World/Objects/Projectiles/PotionProjectile.tscn")

onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")

var is_throwing: bool = false
var animation: String = ""
var direction: String = "DOWN"

enum {
	MOVEMENT, 
	SWINGING,
	EATING,
	FISHING,
	HARVESTING,
	DYING,
	SLEEPING,
	SITTING,
	MAGIC_CASTING,
	THROWING
}

func _physics_process(delta):
	if not is_throwing:
		return
	var degrees = int($ThrowDirection.rotation_degrees) % 360
	$ThrowDirection.look_at(get_global_mouse_position())
	if $ThrowDirection.rotation_degrees >= 0:
		if degrees <= 45 or degrees >= 315:
			direction = "RIGHT"
		elif degrees <= 135:
			direction = "DOWN"
		elif degrees <= 225:
			direction = "LEFT"
		else:
			direction = "UP"
	else:
		if degrees >= -45 or degrees <= -315:
			direction = "RIGHT"
		elif degrees >= -135:
			direction = "UP"
		elif degrees >= -225:
			direction = "LEFT"
		else:
			direction = "DOWN"
	if get_parent().state != DYING and is_throwing:
		composite_sprites.set_player_animation(get_parent().character, "throw_" + direction.to_lower(), null)


func throw_potion(potion_name, init_direction):
	PlayerInventory.remove_single_object_from_hotbar()
	is_throwing = true
	direction = init_direction
	get_parent().state = MAGIC_CASTING
	composite_sprites.set_player_animation(get_parent().character, "throw_" + direction.to_lower(), null)
	player_animation_player.play("bow draw release")
	yield(player_animation_player, "animation_finished" )
	throw(potion_name)
	is_throwing = false
	get_parent().state = MOVEMENT
	get_parent().direction = direction
	
func throw(potion_name):
	var potion = PotionProjectile.instance()
	potion.potion_name = potion_name
	potion.particles_transform = $ThrowDirection.transform
	potion.target = get_global_mouse_position()
	potion.position = $ThrowDirection/Position2D.global_position
	get_node("../../../").add_child(potion)
