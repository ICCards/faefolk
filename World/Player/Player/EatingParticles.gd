extends Node2D


onready var player_animation_player = get_node("../CompositeSprites/AnimationPlayer")
onready var composite_sprites = get_node("../CompositeSprites")

var color1
var color2
var color3
var color4
var color5
var color6
var color7
var color8

enum {
	MOVEMENT, 
	SWING,
	EATING,
	FISHING,
	CHANGE_TILE
}
var rng = RandomNumberGenerator.new()


func eat(food):
	if get_parent().state != EATING:
		get_parent().state = EATING
		PlayerStats.eat(food)
		set_particle_colors(food)
		#yield(get_tree().create_timer(0.1), "timeout")
		composite_sprites.set_player_animation(get_parent().character, "eat", null)
		player_animation_player.play("eat")
		yield(player_animation_player, "animation_finished")
		get_parent().state = MOVEMENT
	
func set_particle_colors(item_name):
	var itemImage = Image.new()
	itemImage.load("res://Assets/Images/inventory_icons/Food/" + item_name + ".png")
	itemImage.lock()
	$EatingParticles1.color = return_pixel_color(itemImage)
	$EatingParticles2.color = return_pixel_color(itemImage)
	$EatingParticles3.color = return_pixel_color(itemImage)
	$EatingParticles4.color = return_pixel_color(itemImage)
	$EatingParticles5.color = return_pixel_color(itemImage)
	$EatingParticles6.color = return_pixel_color(itemImage)
	$EatingParticles7.color = return_pixel_color(itemImage)
	$EatingParticles8.color = return_pixel_color(itemImage)
	
	
func return_pixel_color(image):
	rng.randomize()
	var tempColor = Color(image.get_pixel(rng.randi_range(8, 24), rng.randi_range(8, 24)))
	if tempColor != Color(0,0,0,0):
		return tempColor
	else:
		tempColor = Color(image.get_pixel(rng.randi_range(8, 24), rng.randi_range(8, 24)))
		if tempColor != Color(0,0,0,0):
			return tempColor
		else:
			return Color(0,0,0,0)
