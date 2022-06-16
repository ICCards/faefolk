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

const _character = preload("res://Global/Data/Characters.gd")
onready var character = _character.new()

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
	bodySprite.texture = character.body_sprites[anim]
	armsSprite.texture = character.arms_sprites[anim]
	accessorySprite.texture = character.acc_sprites[anim]
	headAttributeSprite.texture = character.headAtr_sprites[anim]
	pantsSprite.texture = character.pants_sprites[anim]
	shirtsSprite.texture = character.shirts_sprites[anim]
	shoesSprite.texture = character.shoes_sprites[anim]
	
	
func _ready():
	animPlayer.play("idle")
	$SoundEffects.play()
	setAnimationTexture("idle_down")
	character.LoadPlayerCharacter("human_male")
#	bodySprite.texture = Characters.body_sprites['idle_down']
#	armsSprite.texture = Characters.arms_sprites['idle_down']
#	accessorySprite.texture = Characters.acc_sprites['idle_down']
#	headAttributeSprite.texture = Characters.headAtr_sprites['idle_down']
#	pantsSprite.texture = Characters.pants_sprites['idle_down']
#	shirtsSprite.texture = Characters.shirts_sprites['idle_down']
#	shoesSprite.texture = Characters.shoes_sprites['idle_down']

	
