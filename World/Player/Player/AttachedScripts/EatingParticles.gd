extends Node2D


var color1
var color2
var color3
var color4
var color5
var color6
var color7
var color8

var item_name
var category
var tempColor

var rng = RandomNumberGenerator.new()

func _ready():
	eat()

func eat():
	PlayerData.eat(item_name)
	set_particle_colors(item_name)
	$EatingParticles1.emitting = true
	$EatingParticles2.emitting = true
	$EatingParticles3.emitting = true
	$EatingParticles4.emitting = true
	$EatingParticles5.emitting = true
	$EatingParticles6.emitting = true
	$EatingParticles7.emitting = true
	$EatingParticles8.emitting = true
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
	
func set_particle_colors(item_name):
	var itemImage = Image.new()
	category = JsonData.item_data[item_name]["ItemCategory"]
	var stream_texture = load("res://Assets/Images/inventory_icons/" + category +"/" + item_name + ".png")
	var image_texture = ImageTexture.new()
	itemImage = stream_texture.get_data()
	false # itemImage.lock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed # so i can modify pixel data
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
	tempColor = Color(image.get_pixel(rng.randi_range(4, 12), rng.randi_range(4, 12)))
	if tempColor != Color(0,0,0,0):
		return tempColor
	else:
		tempColor = Color(image.get_pixel(rng.randi_range(4, 12), rng.randi_range(4, 12)))
		if tempColor != Color(0,0,0,0):
			return tempColor
		else:
			return Color(0,0,0,0)
