@tool
extends ImageTexture
class_name CustomGradientTexture

enum GradientType {LINEAR, RADIAL, RECTANGULAR}

# Workaround for manual texture update
# because updating it while editing the gradient doesn't work well
enum Btn {ClickToUpdateTexture}
@export var click_to_update_texture: bool = false : set = _update_texture

@export var type: GradientType = GradientType.LINEAR : set = set_type
@export var size = Vector2(1000, 1000) : set = set_size
@export var gradient: Gradient : set = set_gradient

var data: Image

func _init():
	#data = Image.new()
	data = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	#print(size.x)
	#data.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	#print(str(data.get_width()))

func _update():
	if not gradient:
		return
	var radius = (size - Vector2(1.0, 1.0)) / 2
	var ratio = size.x / size.y
	if type == GradientType.LINEAR:
		for x in range(size.x):
			var offset = float(x) / (size.x - 1)
			var color = gradient.sample(offset)

			for y in range(size.y):
				data.set_pixel(x, y, color)

	elif type == GradientType.RADIAL:
		for x in range(size.x):
			for y in range(size.y):
				var dist = Vector2(x / ratio, y).distance_to(Vector2(radius.x / ratio, radius.y))
				var offset = dist / radius.y
				var color = gradient.sample(offset)
				data.set_pixel(x, y, color)

	# Rectangular
	else:
		for x in range(size.x):
			for y in range(size.y):
				var dist_x = Vector2(x, 0).distance_to(Vector2(radius.x, 0))
				var dist_y = Vector2(0, y).distance_to(Vector2(0, radius.y))
				var offset

				if dist_x > dist_y * ratio:
					offset = dist_x / radius.x
				else:
					offset = dist_y / radius.y

				var color = gradient.sample(offset)
				data.set_pixel(x, y, color)
	#var texture = ImageTexture.new()
	set_image(data)


# Workaournd that allow to manual update the texture
#warning-ignore:unused_argument
func _update_texture(value):
	_update();

func set_type(value):
	type = value
	_update()

func set_size(value):
	size = value

	if size.x > 4096:
		size.x = 4096
	if size.y > 4096:
		size.y = 4096
	#data.resize(size.x, size.y)
	_update()

func set_gradient(value):
	gradient = value
	_update()
