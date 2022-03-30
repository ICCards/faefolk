extends KinematicBody2D

export(int) var speed = 280.0

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped

onready var animPlayer = $CompositeSprites/AnimationPlayer
	
var state = MOVEMENT
enum {
	MOVEMENT, 
	SWING
}

var direction = DOWN
enum {
	DOWN,
	UP,
	LEFT,
	RIGHT
}


func _process(delta):
	if $PickupZone.items_in_range.size() > 0:
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)
	match state:
		MOVEMENT:
			movement_state(delta)
		SWING:
			swing_state(delta)

func swing_state(_delta):
	match direction: 
		DOWN:
			animPlayer.play("swing_down")
			setAnimationTexture("swing_down")
		UP: 
			animPlayer.play("swing_up")
			setAnimationTexture("swing_up")
		LEFT: 
			animPlayer.play("swing_left")
			setAnimationTexture("swing_left")
		RIGHT:
			animPlayer.play("swing_right")	
			setAnimationTexture("swing_right")
	yield(animPlayer, "animation_finished" )
	state = MOVEMENT


func movement_state(_delta):
	if Input.is_action_pressed("mouse_click"):
		state = SWING
	animPlayer.play("movement")
	var velocity = Vector2.ZERO					
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
		direction = UP
		setAnimationTexture("walk_up")
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
		direction = DOWN
		setAnimationTexture("walk_down")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
		direction = LEFT
		setAnimationTexture("walk_left")
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
		direction = RIGHT
		setAnimationTexture("walk_right")
	if Input.is_action_pressed("ui_right") == false && Input.is_action_pressed("ui_left") == false && Input.is_action_pressed("ui_up") == false && Input.is_action_pressed("ui_down") == false && Input.is_action_pressed("mouse_click") == false:
		match direction: 
			DOWN:
				setAnimationTexture("idle_down")
			UP: 
				setAnimationTexture("idle_up")
			LEFT: 
				setAnimationTexture("idle_left")
			RIGHT:
				setAnimationTexture("idle_right")
		
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)


func setAnimationTexture(var anim):
	bodySprite.set_texture(Global.body_sprites[anim])
	armsSprite.set_texture(Global.arms_sprites[anim])
	accessorySprite.set_texture(Global.acc_sprites[anim])
	headAttributeSprite.set_texture(Global.headAtr_sprites[anim])
	pantsSprite.set_texture(Global.pants_sprites[anim])
	shirtsSprite.set_texture(Global.shirts_sprites[anim])
	shoesSprite.set_texture(Global.shoes_sprites[anim])
	toolEquippedSprite.set_texture(Global.axe_sprites[anim])

