extends KinematicBody2D

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var animPlayer = $CompositeSprites/AnimationPlayer

export var speed := 400.0

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		setAnimationTexture('walk_left')
		velocity.x -= 1.0
		$AudioStreamPlayer.stream = Global.dirt_footsteps
	if Input.is_action_pressed("ui_right"):
		setAnimationTexture('walk_right')	
		velocity.x += 1.0
		$AudioStreamPlayer.stream = Global.dirt_footsteps
	if (Input.is_action_pressed("ui_right") == false && Input.is_action_pressed("ui_left") == false):
		velocity = Vector2.ZERO
		setAnimationTexture('idle_down')
		$AudioStreamPlayer.stream = Global.dirt_footsteps
		
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)
	
	
#func _input(event):
#	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
#		playSound = true
	#_play_sound_effect()
#	else:
#		#playSound = false
#		print("stop")
#		$AudioStreamPlayer.stop()


var playSound = false
func _play_sound_effect():
	if playSound:
		$AudioStreamPlayer.stream = Global.dirt_footsteps
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()

func setAnimationTexture(var anim):
	bodySprite.texture = Global.body_sprites[anim]
	armsSprite.texture = Global.arms_sprites[anim]
	accessorySprite.texture = Global.acc_sprites[anim]
	headAttributeSprite.texture = Global.headAtr_sprites[anim]
	pantsSprite.texture = Global.pants_sprites[anim]
	shirtsSprite.texture = Global.shirts_sprites[anim]
	shoesSprite.texture = Global.shoes_sprites[anim]
	
	
func _ready():
	animPlayer.play("idle")
	$AudioStreamPlayer.play()
	Global.randomizeAttributes()
	bodySprite.texture = Global.body_sprites['idle_down']
	armsSprite.texture = Global.arms_sprites['idle_down']
	accessorySprite.texture = Global.acc_sprites['idle_down']
	headAttributeSprite.texture = Global.headAtr_sprites['idle_down']
	pantsSprite.texture = Global.pants_sprites['idle_down']
	shirtsSprite.texture = Global.shirts_sprites['idle_down']
	shoesSprite.texture = Global.shoes_sprites['idle_down']

	
