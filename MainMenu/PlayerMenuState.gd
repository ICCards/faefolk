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
var player

func initialize(_player):
	player = _player


func _ready():
	animPlayer.play("idle")
	$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -4)
	$FootstepsSound.play()
	setAnimationTexture("idle_down")
	character.LoadPlayerCharacter("human_male")
	#character.LoadPlayerCharacter(player["c"])
	Sounds.connect("volume_change", self, "change_footsteps_volume")


func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left") and not get_parent().is_menu_open:
		setAnimationTexture('walk_left')
		velocity.x -= 1.0
		$FootstepsSound.stream_paused = false
	if Input.is_action_pressed("move_right") and not get_parent().is_menu_open:
		setAnimationTexture('walk_right')	
		velocity.x += 1.0
		$FootstepsSound.stream_paused = false
	if !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		velocity = Vector2.ZERO
		setAnimationTexture('idle_down')
		$FootstepsSound.stream_paused = true

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


func change_footsteps_volume():
	$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -16)

