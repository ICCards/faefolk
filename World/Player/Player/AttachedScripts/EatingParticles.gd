extends Node2D

var rng = RandomNumberGenerator.new()

var color1
var color2
var color3
var color4
var color5
var color6
var color7
var color8

var item_name

func _ready():
	var itemImage = Image.new()
	itemImage.load("res://Assets/Images/inventory_icons/Food/" + item_name + ".png")
	itemImage.lock()
	set_pixel_colors(itemImage)
	print("START")
	$EatingParticles1.emitting = true
	$EatingParticles2.emitting = true
	$EatingParticles3.emitting = true
	$EatingParticles4.emitting = true
	$EatingParticles5.emitting = true
	$EatingParticles6.emitting = true
	$EatingParticles7.emitting = true
	$EatingParticles8.emitting = true
	yield(get_tree().create_timer(1.2), "timeout")
	queue_free()


func set_pixel_colors(itemImage):
	color1 = return_pixel_color(itemImage)
	color2 = return_pixel_color(itemImage)
	color3 = return_pixel_color(itemImage)
	color4 = return_pixel_color(itemImage)
	color5 = return_pixel_color(itemImage)
	color6 = return_pixel_color(itemImage)
	color7 = return_pixel_color(itemImage)
	color8 = return_pixel_color(itemImage)


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
