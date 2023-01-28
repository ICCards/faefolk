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
var character
var player

onready var _character = load("res://Global/Data/Characters.gd")

func _ready():
	Server.player_node = self
	character = _character.new()
	character.LoadPlayerCharacter("human_male")
	animPlayer.play("idle")
	$FootstepsSound.volume_db = Sounds.return_adjusted_sound_db("footstep", -4)
	$FootstepsSound.play()
	setAnimationTexture("idle_down")
	Sounds.connect("volume_change", self, "change_footsteps_volume")


func destroy():
	set_physics_process(false)
	character.queue_free()
	Server.player_node = null

func _physics_process(_delta):
	if not visible:
		return
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		setAnimationTexture('walk_left')
		velocity.x -= 1.0
		$FootstepsSound.stream_paused = false
	if Input.is_action_pressed("move_right"):
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

