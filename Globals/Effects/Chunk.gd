extends Sprite

var d := 0.0
var radius := 0.0
var speed := 0.0
var downOffset := 0



var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	radius += rng.randi_range(8, 13)
	rng.randomize()
	speed += rng.randi_range(4, 6)
	rng.randomize()
	set_frame(rng.randi_range(0 , 11))

func _process(delta):
	d += delta
	
	#rotation +=  radius * 0.01
	if int(radius) % 2 == 0:
		position = Vector2(
			sin(d * speed) * radius,
			cos(d * speed) * radius
		) + Vector2(50, 50)
	else :
		position = Vector2(
			cos(d * speed) * radius,
			sin(d * speed) * radius
		) + Vector2(50, 50)
		
