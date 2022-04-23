extends Node2D


func init(tree):
	$Chunk.texture = tree.leaves
	$CPUParticles2D.texture = tree.leaves


func _ready():
	randomize()
	var t = rand_range(4, 8)
	yield(get_tree().create_timer(t),"timeout")
	#$CPUParticles2D.set_frame(rand_range(0 , 11))
	queue_free()

var d := 0
var radius := 6
var speed := 4

func _process(delta):
	d += delta
	#rotation +=  radius * 0.01
	if int(radius) % 2 == 0:
		$CPUParticles2D.position = Vector2(
			sin(d * speed) * radius,
			cos(d * speed) * radius
		) + Vector2(50, 50)
	else :
		$CPUParticles2D.position = Vector2(
			cos(d * speed) * radius,
			sin(d * speed) * radius
		) + Vector2(50, 50)
