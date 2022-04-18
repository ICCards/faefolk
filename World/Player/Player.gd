extends KinematicBody2D

export(int) var speed = 260.0

onready var bodySprite = $CompositeSprites/Body
onready var armsSprite = $CompositeSprites/Arms
onready var accessorySprite = $CompositeSprites/Accessory
onready var headAttributeSprite = $CompositeSprites/HeadAtr
onready var pantsSprite = $CompositeSprites/Pants
onready var shirtsSprite = $CompositeSprites/Shirts
onready var shoesSprite = $CompositeSprites/Shoes
onready var toolEquippedSprite = $CompositeSprites/ToolEquipped
onready var animation_player = $CompositeSprites/AnimationPlayer
	
	
onready var state = MOVEMENT
enum {
	MOVEMENT, 
	SWING
}

onready var direction = "DOWN"

func _process(delta) -> void:
	if PlayerInventory.viewInventoryMode == false:
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
		match state:
			MOVEMENT:
				movement_state(delta)
	else: 
		idle_state(direction)

	
		
func _unhandled_input(event):
	if PlayerInventory.hotbar.has(PlayerInventory.active_item_slot) and PlayerInventory.viewInventoryMode == false and get_owner() != get_node("/root/InsidePlayerHome"):
		print(get_owner())
		var item_name = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
		var itemCategory = JsonData.item_data[item_name]["ItemCategory"]
		if event.is_action_pressed("mouse_click") and itemCategory == "Weapon":
			state = SWING
			swing_state(event, item_name)




func movement_state(delta):
	animation_player.play("movement")
	var velocity = Vector2.ZERO			
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
		direction = "UP"
		walk_state(direction)
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
		direction = "DOWN"
		walk_state(direction)
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
		direction = "LEFT"
		walk_state(direction)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
		direction = "RIGHT"
		walk_state(direction)		
	if Input.is_action_pressed("ui_right") == false && Input.is_action_pressed("ui_left") == false && Input.is_action_pressed("ui_up") == false && Input.is_action_pressed("ui_down") == false:
		idle_state(direction)
			
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)	


var swingActive = false
func swing_state(_delta, weaponType):
		if !swingActive:
				var toolName = PlayerInventory.hotbar[PlayerInventory.active_item_slot][0]
				swingActive = true
				set_melee_collision_layer(toolName)
				toolEquippedSprite.set_texture(Global.returnToolSprite(toolName, direction.to_lower()))
				setPlayerTexture("swing_" + direction.to_lower())
				animation_player.play("swing_" + direction.to_lower())
				yield(animation_player, "animation_finished" )
				toolEquippedSprite.texture = null
				state = MOVEMENT
				swingActive = false
		elif swingActive == true:
			pass
		else:
			state = MOVEMENT


func idle_state(direction):
	setPlayerTexture("idle_" + direction.to_lower())

func walk_state(direction):
	setPlayerTexture("walk_" + direction.to_lower())

func set_melee_collision_layer(toolName):
	if toolName == "Axe": 
		$MeleeSwing.set_collision_mask(8)
	elif toolName == "Pickaxe":
		$MeleeSwing.set_collision_mask(16)
	elif toolName == "Hoe":
		$MeleeSwing.set_collision_mask(0)
	elif toolName == "Bucket":
		$MeleeSwing.set_collision_mask(0)
	elif toolName == "Sword":
		$MeleeSwing.set_collision_mask(0)
		
func setPlayerTexture(var anim):
	bodySprite.set_texture(Global.body_sprites[anim])
	armsSprite.set_texture(Global.arms_sprites[anim])
	accessorySprite.set_texture(Global.acc_sprites[anim])
	headAttributeSprite.set_texture(Global.headAtr_sprites[anim])
	pantsSprite.set_texture(Global.pants_sprites[anim])
	shirtsSprite.set_texture(Global.shirts_sprites[anim])
	shoesSprite.set_texture(Global.shoes_sprites[anim])
	
func _ready():
	setPlayerTexture('idle_down')


var sceneTransitionFlag = false
func _on_EnterDoors_area_entered(area):
	sceneTransitionFlag = true

func _on_EnterDoors_area_exited(area):
	sceneTransitionFlag = false
