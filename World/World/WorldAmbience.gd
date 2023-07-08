extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY


signal time_tick(day:int, hour:int, minute:int)


@export var gradient_texture:GradientTexture1D
var INGAME_SPEED = 10.0 / 3.0
var INITIAL_HOUR

var time: float
var past_minute:int= -1

func _process(delta: float) -> void:
	if time:
		time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
		
		var value = (sin(time - PI / 2.0) + 1.0) / 2.0
		self.color = gradient_texture.gradient.sample(value)
	
func initialize(mins,hour):
	INITIAL_HOUR = hour + (mins/60.0)
	time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR
	
	
