extends CharacterBody2D

@onready var bodySprite = $CompositeSprites/Body
@onready var armsSprite = $CompositeSprites/Arms
@onready var accessorySprite = $CompositeSprites/Accessory
@onready var headAttributeSprite = $CompositeSprites/HeadAtr
@onready var pantsSprite = $CompositeSprites/Pants
@onready var shirtsSprite = $CompositeSprites/Shirts
@onready var shoesSprite = $CompositeSprites/Shoes
@onready var toolEquippedSprite = $CompositeSprites/ToolEquipped

@onready var animation_player = $CompositeSprites/AnimationPlayer
var character

var swing_queue = []
var swingActive = false
var direction = "down"
var principal
var username_callback = JavaScript.create_callback(self, "_username_callback")
var counter = -1
var collisionMask = null

func _ready():
	print("player template added")
	set_username("")
	#IC.getUsername(principal,username_callback)
	setPlayerTexture("idle_" + direction)
	animation_player.play("movement")

func _username_callback(args):
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	#	var player_id = json["id"]
	#	var principal = json["principal"]
	set_username(js_event)	
	
func DisplayMessageBubble(message):
	$MessageBubble.visible = true
	if $Timer.time_left > 0:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		#adjust_bubble_position($MessageBubble.get_line_count())
		$Timer.stop()
		$Timer.start()
		await $Timer.timeout
		$MessageBubble.visible = false
	else:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		$Timer.start()
		#adjust_bubble_position($MessageBubble.get_line_count())
		await $Timer.timeout
		$MessageBubble.visible = false

func adjust_bubble_position(lines):
	$MessageBubble.position = $MessageBubble.position + Vector2(0, 4 * (lines - 1))


	
func set_username(username):
	$Username.text = str(username)

func getCharacterById(player_id):
	Server._getCharacterById(player_id)


func move(new_position, _direction):
	if _direction != null:
		direction = _direction.to_lower()
		if !swingActive:
			animation_player.play("movement")
			if new_position == position:
				setPlayerTexture("idle_" + direction)
			else: 
				setPlayerTexture("walk_" + direction)
				set_position(new_position)
				#move_and_collide(new_position)
func Swing(tool_name, direction):
	print(tool_name)
	print(direction)
	swingActive = true
	toolEquippedSprite.set_texture(Images.returnToolSprite(tool_name, "swing_" + direction.to_lower()))
	setPlayerTexture("swing_" + direction.to_lower())
	animation_player.play("swing")
	await animation_player.animation_finished
	toolEquippedSprite.texture = null
	swingActive = false
	#MovePlayer(position, direction.to_lower())


func setPlayerTexture(anim):
	bodySprite.set_texture(character.body_sprites[anim])
	armsSprite.set_texture(character.arms_sprites[anim])
	accessorySprite.set_texture(character.acc_sprites[anim])
	headAttributeSprite.set_texture(character.headAtr_sprites[anim])
	pantsSprite.set_texture(character.pants_sprites[anim])
	shirtsSprite.set_texture(character.shirts_sprites[anim])
	shoesSprite.set_texture(character.shoes_sprites[anim])
	

func _on_VisibilityNotifier2D_screen_entered():
	visible = true

func _on_VisibilityNotifier2D_screen_exited():
	visible = false
