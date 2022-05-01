extends KinematicBody2D

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var animPlayer = $CompositeSprites/AnimationPlayer

export var speed := 300.0

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		setAnimationTexture('walk_left')
		velocity.x -= 1.0
		$SoundEffects.stream_paused = false
	if Input.is_action_pressed("ui_right"):
		setAnimationTexture('walk_right')	
		velocity.x += 1.0
		$SoundEffects.stream_paused = false
	if !Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
		velocity = Vector2.ZERO
		setAnimationTexture('idle_down')
		$SoundEffects.stream_paused = true
		
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)
	


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
	$SoundEffects.play()
	Global.randomizeAttributes()
	bodySprite.texture = Global.body_sprites['idle_down']
	armsSprite.texture = Global.arms_sprites['idle_down']
	accessorySprite.texture = Global.acc_sprites['idle_down']
	headAttributeSprite.texture = Global.headAtr_sprites['idle_down']
	pantsSprite.texture = Global.pants_sprites['idle_down']
	shirtsSprite.texture = Global.shirts_sprites['idle_down']
	shoesSprite.texture = Global.shoes_sprites['idle_down']

	
