extends Camera2D


@onready var timer_shake_length = $timer_shake_length
@onready var timer_wait_times = $timer_wait_times

var time_of_shake = 3.0
var speed_of_shake = 0.02
var strength_of_shake = 3.0

var time_of_small_shake = 0.5
var strength_of_small_shake = 1.5

var time_of_player_hit_shake = 0.25
var strength_of_player_hit_shake = 1.0

var reset_speed = 0
var strength = 0
var doing_shake = false

#connect out timer signal timeouts
func _ready():
	if not get_parent().is_multiplayer_authority(): queue_free()
	timer_wait_times.connect("timeout",Callable(self,"timeout_wait_times"))
	timer_shake_length.connect("timeout",Callable(self,"timeout_shake_length"))
	
#This will stop the shake, and return camera offset to original value
func timeout_shake_length():
	doing_shake = false
	reset_camera()
	
#This function does the tween shaking between intervals
func timeout_wait_times():
	if(doing_shake):
		var tween = get_tree().create_tween()
		tween.tween_property(self,"offset", Vector2(randf_range(-strength,strength),randf_range(-strength,strength)),reset_speed)
		
#once we've finished shaking the screen, tween to original offset
func reset_camera():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"offset",Vector2(0,0),reset_speed)
	
#we're telling the camera to start the shake, and pass some varibles to used in functions else where
func start_shake():
	doing_shake = true
	strength = strength_of_shake
	reset_speed = speed_of_shake
	timer_shake_length.start(time_of_shake)
	timer_wait_times.start(speed_of_shake)
	
	
func player_hit_screen_shake():
	doing_shake = true
	strength = strength_of_small_shake
	reset_speed = speed_of_shake
	timer_shake_length.start(time_of_small_shake)
	timer_wait_times.start(speed_of_shake)
	
func start_small_shake():
	doing_shake = true
	strength = strength_of_player_hit_shake
	reset_speed = speed_of_shake
	timer_shake_length.start(time_of_player_hit_shake)
	timer_wait_times.start(speed_of_shake)
	
func ore_hit_shake():
	doing_shake = true
	strength = strength_of_player_hit_shake / 2
	reset_speed = speed_of_shake / 2
	timer_shake_length.start(time_of_player_hit_shake/2)
	timer_wait_times.start(speed_of_shake/2)
	
##This is our flash tween, we tween up, then once we reach up, yield will fire, and we'll tween back down
#func start_flash(speed,strength):
#	tween_shake.interpolate_property(flash_image,"modulate:a",0,strength,speed,Tween.TRANS_SINE,Tween.EASE_OUT)
#	tween_shake.start()
#
#	await get_tree().create_timer(speed).timeout
#	tween_shake.interpolate_property(flash_image,"modulate:a",strength,0,speed,Tween.TRANS_SINE,Tween.EASE_OUT)
#	tween_shake.start()
