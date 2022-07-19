extends KinematicBody2D

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped

onready var animation_player = $CompositeSprites/AnimationPlayer
var character

var swing_queue = []
var swingActive = false
var direction = "down"
var principal
var username_callback = JavaScript.create_callback(self, "_username_callback")
var counter = -1 #testing value
var collisionMask = null

func _ready():
	set_username("")
	IC.getUsername(principal,username_callback)
	setPlayerTexture("idle_" + direction)

#reset object state to that in a given game_state, executed once per rollback 
func reset_state(game_state : Dictionary):
	#check if this object exists within the checked game_state
	if game_state.has(name):
		position.x = game_state[name]['x']
		position.y = game_state[name]['y']
		counter = game_state[name]['counter']
		collisionMask = game_state[name]['collisionMask']
	else:
		free()

func input_update(input, game_state : Dictionary):
	#calculate state of object for the given input
	var vect = Vector2(0, 0)

#	#Collision detection for moving objects that can pass through each other
#	for object in game_state:
#		if object != name:
#			if collisionMask.intersects(game_state[object]['collisionMask']):
#				counter += 1

	if input.net_input[0]: #W
		vect.y += 7

	if input.net_input[1]: #A
		vect.x += 7

	if input.net_input[2]: #S
		vect.y -= 7

	if input.net_input[3]: #D
		vect.x -= 7

	if input.net_input[4]: #SPACE
		counter = counter/2

	#move_and_collide for "solid" stationary objects
	var collision = move_and_collide(vect)
	if collision:
		vect = vect.slide(collision.normal)
		move_and_collide(vect)

	#collisionMask = Rect2(Vector2(position.x - rectExtents.x, position.y - rectExtents.y), Vector2(rectExtents.x, rectExtents.y) * 2)

func frame_start():
	pass

func frame_end():
	#code to run at end of frame (after all input_update calls)
	pass


func get_state():
	#return dict of state variables to be stored in Frame_States
	return {'x': position.x, 'y': position.y, 'counter': counter, 'collisionMask': collisionMask}	

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
		yield($Timer, "timeout")
		$MessageBubble.visible = false
	else:
		$MessageBubble.text = ""
		$MessageBubble.text = message
		$Timer.start()
		#adjust_bubble_position($MessageBubble.get_line_count())
		yield($Timer, "timeout")
		$MessageBubble.visible = false

func adjust_bubble_position(lines):
	$MessageBubble.rect_position = $MessageBubble.rect_position + Vector2(0, 4 * (lines - 1))


	
func set_username(username):
	$Username.text = str(username)

func getCharacterById(player_id):
	Server._getCharacterById(player_id)

#func MovePlayer(new_position, _direction):
##	if not new_position == position:
##		pass
#	direction = _direction.to_lower()
#	if !swingActive:
#		animation_player.play("movement")
#		if new_position == position:
#			setPlayerTexture("idle_" + direction)
#		else: 
#			setPlayerTexture("walk_" + direction)
#			set_position(new_position)

func Swing(tool_name, direction):
	print(tool_name)
	print(direction)
	swingActive = true
	toolEquippedSprite.set_texture(Images.returnToolSprite(tool_name, "swing_" + direction.to_lower()))
	setPlayerTexture("swing_" + direction.to_lower())
	animation_player.play("swing")
	yield(animation_player, "animation_finished")
	toolEquippedSprite.texture = null
	swingActive = false
	#MovePlayer(position, direction.to_lower())


func setPlayerTexture(var anim):
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
